//
//  ExerciseViewController.swift
//  fitspire
//
//  Created by LUNVCA on 7/20/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit
import CoreData

class DisplayWorkoutViewController: UIViewController{
    @IBOutlet var workoutLabel : UILabel!
    @IBOutlet weak var workoutTableView: UITableView!
    var exercises: [NSManagedObject] = []
    var workoutName : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutLabel.text = workoutName
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
       
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Exercises")
        fetchRequest.predicate = NSPredicate(format: "workoutName == %@", self.workoutName)
        
        do {
            exercises = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
}

//TableView Extensions

extension DisplayWorkoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let thisExercise = exercises[indexPath.row]
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath) as! WorkoutTableViewCell
            cell.workoutLabel.text = thisExercise.value(forKeyPath: "exerciseName") as? String
            cell.workoutPic.image = UIImage(named: "tricepdips.png")
            return cell
    }
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Segue to the second view controller
        self.performSegue(withIdentifier: "yourSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            let disExercise = exercises[indexPath.row]
            context.delete(disExercise)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Exercises")
            do {
                exercises = try context.fetch(fetchRequest)
            } catch {
                print("Fetching Failed")
            }
        }
        tableView.reloadData()
    }
}
