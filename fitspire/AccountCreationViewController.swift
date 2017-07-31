//
//  AccountCreationViewController.swift
//  fitspire
// this class will help with username selection and checking
//  Created by LUNVCA on 7/29/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit
import CloudKit

class AccountCreationViewController: UIViewController {
    @IBOutlet var userNameField : UITextField!
    @IBOutlet var create : UIButton!
    var userCKID : String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //this function will fetch the user's cloudkit id
        iCloudUserIDAsync { (recordID: CKRecordID?, error: NSError?) in
            if let userID = recordID?.recordName {
                self.userCKID = userID
                print("received iCloudID \(userID)")
            } else {
                print("Fetched iCloudID was nil")
            }
        }
    }

    
    //async gets iCloud record ID object of logged-in iCloud user
    func iCloudUserIDAsync(complete: @escaping (_ instance: CKRecordID?, _ error: NSError?) -> ()) {
        let container = CKContainer.default()
        container.fetchUserRecordID() {
            recordID, error in
            if error != nil {
                print(error!.localizedDescription)
                complete(nil, error as NSError?)
            } else {
                complete(recordID, nil)
            }
        }
    }
   //this function will create the user if the username and ckid aren't
    //in the cloud, will let user know if it is
    @IBAction func buttonPressed(sender: UIButton){
        userNameField.endEditing(true)
        //grab the username
        let userName = userNameField.text!
        //create ck operation
        let container = CKContainer.default()
        let publicData = container.publicCloudDatabase
        let predicate = NSPredicate(format: "username = %@",
                                    userName)
        let query = CKQuery(recordType: "User", predicate: predicate)
        publicData.perform(query, inZoneWith: nil,
                                 completionHandler: ({results, error in
                                    //if there is an error
                                    if (error != nil) {
                                        //print error to user
                                        DispatchQueue.main.async() {
                                          print("Cloud Access Error \(error!.localizedDescription) ")
                                        }
                                    }
                                        //if there is a record found
                                    else {
                                        if results!.count > 0 {
                                            print("record found")
                                            
                                            DispatchQueue.main.async() {
                                            let alert = UIAlertController(title: "Error", message: "Username already exists. Please try another name.", preferredStyle: .alert)
                                        
                                            }
                                        }
                                            //we're good to go, there isn't already a user with that name!
                                        else {
                                            // go ahead and create user
                                            DispatchQueue.main.async() {
                                               
                                                let userRecordID = CKRecordID(recordName: userName)
                                                let userRecord = CKRecord(recordType: "User", recordID: userRecordID )
                                                userRecord["username"] = userName as NSString
                                                userRecord["CKID"] = self.userCKID as NSString
                                                let defaults = UserDefaults.standard
                                                defaults.set(userName, forKey: "username")
                                                publicData.save(userRecord) {
                                                    (record, error) in
                                                    if error != nil {
                                                        // Insert error handling
                                                        return
                                                    }
                                                  print("Sucess, Acount Created")
                                                
                                                self.performSegue(withIdentifier: "Begin", sender: self)
                                                }
                                            }
                                        }
                                    }
                                 }))
    
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
