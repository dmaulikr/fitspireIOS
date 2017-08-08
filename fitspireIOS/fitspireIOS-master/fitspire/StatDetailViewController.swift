//
//  StatDetailViewController.swift
//  fitspire
//
//  Created by LUNVCA on 8/1/17.
//  Copyright © 2017 uca. All rights reserved.
//


import UIKit
import CoreData
import CloudKit

class StatDetailViewController: UIViewController{
    @IBOutlet var workoutLabel : UILabel!
    @IBOutlet weak var statTableView: UITableView!
    var stats: [CKRecord] = []
    var workoutID : String!
    var workoutDate : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let container = CKContainer.default()
        let privateDatabase = container.privateCloudDatabase
        let predicate = NSPredicate(format: "instanceID = %@", self.workoutID)
        
        let query = CKQuery(recordType: "setData", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true), NSSortDescriptor(key: "setCount", ascending: true)]
        
        privateDatabase.perform(query, inZoneWith: nil) { (results, error) -> Void in
            
            if error != nil {
                
                print("error fetch notes \(String(describing: error))")
                
            } else {
                
                print("Success")
                
                for result in results! {
                    self.stats.append(result )
                }
                print(self.stats.count)
                
                OperationQueue.main.addOperation({ () -> Void in
                    self.statTableView.reloadData()
              
                })
            }
        }
    }

           }
    
    

extension StatDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return stats.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let workout =  stats[indexPath.row]
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath) as! StatDetailTableViewCell
            var workoutName = workout.value(forKey: "exerciseName") as! String
            cell.exerciseLabel.text = workoutName
            let repCount = workout["reps"] as! Int
            let weight = workout["weight"] as! Int
            let  setCount = workout["setCount"] as! Int
            cell.setCountLabel.text = String(setCount)
            cell.repLabel.text = String(repCount)
            cell.weightLabel.text = String(describing: weight )

        
          
           
            return cell
    }
    
    
        }




