//
//  SaveWorkoutViewController.swift
//  fitspire
//
//  Created by LUNVCA on 7/29/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit
import CloudKit
class SaveWorkoutViewController: UIViewController {
    
    @IBOutlet var background: UIImageView!
    var instanceID : String!
    var logData : [CKRecord]!
    var todaysDate : Date!
    var logRecord : CKRecord?
    var workoutName : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedValue = UserDefaults.standard.string(forKey: "backgroundName") {
            var image = UIImage(named: savedValue)
            background.image = image
        }
        var logRecordID = CKRecordID(recordName: instanceID)
        self.logRecord = CKRecord(recordType: "loggedWorkout", recordID: logRecordID)
        var today = Date()
        let thisDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " YYYY EEEE, MMM dd"
        let todayString = dateFormatter.string(from: thisDate)
        let dateValue = dateFormatter.date(from: todayString) as Date!

        self.logRecord?.setValue(dateValue, forKey: "date")
        self.logRecord?.setValue(workoutName, forKey: "workoutName")
        
        // Do any additional setup after loading the view.
    }
    func saveAll(){
        
        let operation = CKModifyRecordsOperation(recordsToSave: self.logData, recordIDsToDelete: nil)
        CKContainer.default().privateCloudDatabase.add(operation)
        CKContainer.default().privateCloudDatabase.save(self.logRecord!) {
            (record, error) in
            if error != nil {
                print(error!)
                // Insert error handling
                return
            }
            print("Success, Workout Saved")
            
        }

        
    }
    @IBAction func buttonPressed(sender: Any){
    saveAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

