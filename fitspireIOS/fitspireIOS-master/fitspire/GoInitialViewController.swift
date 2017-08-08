//
//  GoInitialViewController.swift
//  fitspire
//
//  Created by LUNVCA on 7/25/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit
import CoreData

class GoInitialViewController: UIViewController, AKPickerViewDelegate,AKPickerViewDataSource {

    @IBOutlet var message : UILabel!
    @IBOutlet var workoutPick : AKPickerView!
    @IBOutlet var goButton : UIButton!
    var workouts : [NSManagedObject] = []
    var workoutNames : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutPick.delegate = self
        workoutPick.dataSource = self
        
        workoutPick.interitemSpacing = 20.0
        workoutPick.font = UIFont(name: "Avenir-Light", size: 22.0)!
        workoutPick.highlightedFont  = UIFont(name: "Avenir-Light", size: 22.0)!
        workoutPick.textColor = UIColor.lightGray
        workoutPick.highlightedTextColor = UIColor.white
        self.workoutPick.reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
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
        if workouts.count != 0{
        for index in 0 ... workouts.count - 1 {
            let thisWorkout = workouts[index]
            let thisWorkoutName = thisWorkout.value(forKey: "workoutName")
            workoutNames.append(thisWorkoutName as! String)
        }
        }
        

        var dateCheck : [NSManagedObject] = []
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        let searchDate = formatter.date(from: result)!
        print(searchDate)
    
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Meta")
        fetchRequest.predicate = NSPredicate(format: "workoutDate == %@", searchDate as CVarArg)
        
        do {
            dateCheck = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let today = dateCheck.first!
        let workoutCheck  = today.value(forKey: "workoutName") as! String?
        
        if( workoutCheck != nil){
            self.workoutPick.isHidden = true
            self.message.text = "The workout you have selected for today is '\(workoutCheck!).' Are you ready to begin? "
            self.message.font = UIFont(name: "Avenir", size: 23)
            self.goButton.isHidden = false
        }
        if ( workoutNames.count == 0){
            self.message.text = "It looks like you don't have any workouts yet, create one and come back to enable GO"
            
            self.workoutPick.isHidden = true
            self.goButton.isHidden = true
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int
    {
     
            return workoutNames.count
     
    }
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
      
            return workoutNames[item]
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toGo"){
            let selectedValue = workoutPick.selectedItem
          let  sentName = workoutNames[selectedValue]
            print(sentName)
            let GO = segue.destination as! CircleSliderViewController
            GO.sentName = sentName
            

        }
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
