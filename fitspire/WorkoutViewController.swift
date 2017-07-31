//
//  ExerciseViewController.swift
//  fitspire
//
//  Created by LUNVCA on 7/20/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit
import CoreData

class WorkoutViewController: UIViewController {

    @IBOutlet weak var workoutTableView: UITableView!
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

    @IBAction func AddWorkout(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Create Workout",
                                      message: "Name For Your New Workout",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            self.save(name: nameToSave)
            self.workoutTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    
    func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1 first get context
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2 then get entity
        let entity =
            NSEntityDescription.entity(forEntityName: "Workouts",
                                       in: managedContext)!
        
        let workout = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        workout.setValue(name, forKeyPath: "workoutName")
        
        // 4
        do {
            try managedContext.save()
            workouts.append(workout)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }


    @IBAction func show(sender: UIButton) {
        if let cell = sender.superview?.superview as? WorkoutTableViewCell {
            let indexPath = workoutTableView.indexPath(for: cell)
            
            self.addingIndex = (indexPath?.row)!
            print(self.addingIndex)
        }
        let addWorkout = workouts[self.addingIndex]
        let workoutName = addWorkout.value(forKey: "workoutName") as! String
        
        
        let actionSheet = UIAlertController(title: workoutName , message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor.green
        
        
        actionSheet.addAction(UIAlertAction(title: "Add to Schedule", style: .default, handler: {action in self.chooseDay()} ))
        actionSheet.addAction(UIAlertAction(title: "Share Workout", style: .default, handler: nil))
        
        
        
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
//TableView Extensions

extension WorkoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
  func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let workout = workouts[indexPath.row]
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath) as! WorkoutTableViewCell
            cell.workoutLabel.text = workout.value(forKeyPath: "workoutName") as? String
            cell.workoutPic.image = UIImage(named: "tricepdips.png")
            return cell
    }
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Segue to the second view controller
        self.performSegue(withIdentifier: "yourSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ShowWorkout" {
            
            
          
            let detailsVC = segue.destination as! DisplayWorkoutViewController
            let cell = sender as! WorkoutTableViewCell
            let thisWorkout = cell.workoutLabel.text as String!
            detailsVC.workoutName = thisWorkout!

    }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            let workout = workouts[indexPath.row]
            context.delete(workout)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
             let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Workouts")
            do {
                workouts = try context.fetch(fetchRequest)
            } catch {
                print("Fetching Failed")
            }
        }
        tableView.reloadData()
    }
}
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
