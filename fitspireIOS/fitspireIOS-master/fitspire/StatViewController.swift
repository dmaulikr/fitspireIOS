//
//  ExerciseViewController.swift
//  fitspire
//
//  Created by LUNVCA on 7/20/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit
import CoreData
import CloudKit
import QuartzCore

class StatViewController: UIViewController {
    
    @IBOutlet weak var workoutTableView: UITableView!
    var logs: [CKRecord] = []
    var addingIndex = 0
    var dates : [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let container = CKContainer.default()
        let privateDatabase = container.privateCloudDatabase
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "loggedWorkout", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        privateDatabase.perform(query, inZoneWith: nil) { (results, error) -> Void in
            
            if error != nil {
                
                print("error fetch notes \(String(describing: error))")
                
            } else {
                
                print("Success")
                
                for result in results! {
                    self.logs.append(result )
                }
                
                OperationQueue.main.addOperation({ () -> Void in
                    self.workoutTableView.reloadData()
                  
                })
            }
        }

        
    }
    
    
}
//TableView Extensions

extension StatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let workout = logs[indexPath.row]
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath) as! StatTableViewCell
            let thisDate = workout.value(forKey: "date") as! Date
           let convertDate =  thisDate.toString(dateFormat: "EEEE, MMMM dd")
            cell.instanceLabel.text = convertDate
            cell.workoutLabel.text = workout["workoutName"] as? String
           cell.workoutLabel.layer.backgroundColor  = UIColor.green.cgColor
           cell.workoutLabel.layer.cornerRadius = 5
          
            return cell
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ShowStats" {
            
            
            
            let detailsVC = segue.destination as! StatDetailViewController
            let cell = sender as! StatTableViewCell
            let indexPath = workoutTableView.indexPath(for: cell)
            var record = logs[(indexPath?.row)!]
            
            print("you selected at   \(String(describing: indexPath?.row))")
            let thisWorkoutDate = cell.workoutLabel.text as String!
            let thisWorkoutID = record.recordID.recordName
            print(thisWorkoutID)
            detailsVC.workoutDate = thisWorkoutDate!
            detailsVC.workoutID = thisWorkoutID
            
        }
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
