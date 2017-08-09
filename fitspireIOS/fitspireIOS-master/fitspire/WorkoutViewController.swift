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
class WorkoutViewController: UIViewController, YNActionSheetDelegate {
    @IBOutlet var background : UIImageView!
    @IBOutlet weak var workoutCollectionView: UICollectionView!
    var workouts: [NSManagedObject] = []
    var addingIndex = 0
    var dates : [NSManagedObject] = []
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedValue = UserDefaults.standard.string(forKey: "backgroundName") {
            var image = UIImage(named: savedValue)
            background.image = image
        }

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
       
        if let cell = sender.superview?.superview?.superview as? WorkoutCollectionViewCell {
            let indexPath = workoutCollectionView.indexPath(for: cell)
            
            self.addingIndex = (indexPath?.row)!
            print(self.addingIndex)
        }
        let addWorkout = workouts[self.addingIndex]
        let workoutName = addWorkout.value(forKey: "workoutName") as! String
        
        displayAction(detail: workoutName)
    }
    func displayAction(detail: String){
        var action = YNActionSheet()
        action.delegate = self as! YNActionSheetDelegate
        action.addCancelButtonWithTitle("Cancel")
        action.addButtonWithTitle(detail)
        action.addButtonWithTitle("Add Workout to Split")
        action.addButtonWithTitle("Add Workout to Day")
        action.addButtonWithTitle("Share Workout")
        self.present(action, animated: true) { () -> Void in
            
        }
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

    func buttonClick(_ index: Int) {
       
        if( index == 1){
            let when = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                self.chooseDay()
            }
            
           
        }
        if(index == 2){
            
        }
        if(index == 3){
            
        }
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
