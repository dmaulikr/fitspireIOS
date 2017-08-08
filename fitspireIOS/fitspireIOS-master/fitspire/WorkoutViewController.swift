//
//  ExerciseViewController.swift
//  fitspire
//
//  Created by LUNVCA on 7/20/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit
import CoreData
import Foundation
class WorkoutViewController: UIViewController {

    @IBOutlet weak var workoutCollectionView: UICollectionView!
    var workouts: [NSManagedObject] = []
    var addingIndex = 0
    var dates : [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
           }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest1 = NSFetchRequest<NSManagedObject>(entityName: "Workouts")
        do {
            workouts = try managedContext.fetch(fetchRequest1)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "Meta")
        do {
            dates = try managedContext.fetch(fetchRequest2)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        
    }

 
    @IBAction func show(sender: UIButton) {
        if let cell = sender.superview?.superview as? WorkoutCollectionViewCell {
            let indexPath = workoutCollectionView.indexPath(for: cell)
            
            self.addingIndex = (indexPath?.row)!
            print(self.addingIndex)
        }
        let addWorkout = workouts[self.addingIndex]
        let workoutName = addWorkout.value(forKey: "workoutName") as! String
        
        
        let actionSheet = UIAlertController(title: workoutName , message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor.green
        
        
        actionSheet.addAction(UIAlertAction(title: "Add to Schedule", style: .default, handler: {action in self.chooseDay()} ))
        actionSheet.addAction(UIAlertAction(title: "Delete Workout", style: .default, handler: nil))
        
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func chooseDay(){
        let actionSheet = UIAlertController(title: "Add Workout To: ", message: nil, preferredStyle: .actionSheet)
        for i in 0...dates.count - 1{
            let stockDate = dates[i].value(forKeyPath: "workoutDate") as! Date
            let dateString = stockDate.toString(dateFormat: " EEEE, MMM dd")
            actionSheet.addAction(UIAlertAction(title: dateString, style: .default, handler: {action in self.addToDay(workoutDate: stockDate)}))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
        
    }
    func delete(sender: Any){
        
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
            let workout = workouts[self.addingIndex]
            context.delete(workout)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Workouts")
            do {
                workouts = try context.fetch(fetchRequest)
            } catch {
                print("Fetching Failed")
            
        }
        workoutCollectionView.reloadData()
    }


    func addToDay(workoutDate: Date){
        var addDate : [NSManagedObject] = []
             let predicate = NSPredicate(format: "workoutDate == %@", workoutDate as CVarArg)
        let addWorkout = workouts[self.addingIndex]
        let workoutName = addWorkout.value(forKey: "workoutName") as! String
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Meta")
        fetchRequest.predicate = predicate
        do {
            addDate = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        addDate.first?.setValue(workoutName, forKey: "workoutName")
        
        
        
        
        do {
            try managedContext.save()
        } catch {
            print("couldn't save workout name to date!")
        }
        
    }

    

  
}
//CollectionView Extensions

extension WorkoutViewController: UICollectionViewDataSource {
    func collectionView(_ CollectionView: UICollectionView,
                   numberOfItemsInSection section: Int) -> Int {
        return workouts.count
    }
    
  func collectionView(_ CollectionView: UICollectionView,
                   cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            
            let workout = workouts[indexPath.row]
            let cell =
                CollectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                              for: indexPath) as! WorkoutCollectionViewCell
            
           var workoutName = workout.value(forKeyPath: "workoutName") as! String
             cell.workoutLabel.text = workoutName.uppercased()
            cell.workoutPic.image = UIImage(named: "strength.png")
            return cell
    }
    // method to run when Collection view cell is tapped
    func CollectionView(_ CollectionView: UICollectionView, didSelectRowAt indexPath: IndexPath) {
        
        // Segue to the second view controller
        self.performSegue(withIdentifier: "yourSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ShowWorkout" {
            
            
          
            let detailsVC = segue.destination as! DisplayWorkoutViewController
            let cell = sender as! WorkoutCollectionViewCell
          let indexPath =  self.workoutCollectionView.indexPath(for: cell)
            
            let thisWorkout = workouts[(indexPath?.row)!].value(forKey: "workoutName") as! String
            detailsVC.workoutName = thisWorkout

    }
    }
}
