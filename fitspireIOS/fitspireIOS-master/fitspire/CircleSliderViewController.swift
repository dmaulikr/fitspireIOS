//
//  CircleSliderViewController.swift
//  CircularSliderExample
//
//  Created by Christopher Olsen on 3/3/16.
//  Copyright © 2016 Christopher Olsen. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class CircleSliderViewController: UIViewController,  AKPickerViewDataSource, AKPickerViewDelegate{
    @IBOutlet var pickerView : AKPickerView!
    @IBOutlet var pickerView1: AKPickerView!
    let weights = ["5", "10", "15","20","25","30","35","40","45", "50"]
    let reps = ["1", "2", "3","4","5","6","7","8","9","10"]
    var sets : [String] = []
    var exercises  : [NSManagedObject] = []
    var exerciseNames : [String] = []
    var logData : [CKRecord] = []
    var sentName : String!
    @IBOutlet var setLabel : UILabel!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet var workoutLabel : UILabel!
    var todaysDate = Date()
    var workoutLabelCount = 0
    var setLabelCount = 0
    var circularSlider: CircularSlider!
    let animation = CATransition()
    let workoutAnimation = CATransition()
    var instanceID : String = ""
    @IBOutlet var progressBar : YLProgressBar!
    var setTotal : Double = 0
    var currentSet :Double = 0
    
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    let result = formatter.string(from: self.todaysDate)
    self.todaysDate = formatter.date(from: result)!
    print(self.todaysDate)
    
    let workoutID = self.sentName!
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Exercises")
    fetchRequest.predicate = NSPredicate(format: "workoutName == %@", workoutID)
    
    do {
        exercises = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    for i in 0 ... exercises.count - 1 {
        let thisExercise = exercises[i]
        exerciseNames.append(thisExercise.value(forKey:"exerciseName") as! String)
        sets.append(thisExercise.value(forKey: "setCount") as! String)
        
    }
    getSetTotal()
    fixUpDisplay()
   
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.instanceID = UUID().uuidString
        print(self.instanceID)
    }
       func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int
    {
        if(pickerView.tag == 1){
        return weights.count
    }
        if(pickerView.tag == 2){
            return reps.count
        }
        return 0
    }
    func getSetTotal(){
        for i in 0 ... sets.count - 1{
            let addString = Int(sets[i])
            
            self.setTotal += Double( addString!)
          
        }
    }
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        if(pickerView.tag == 1){
            return weights[item]
        }
        if(pickerView.tag == 2){
            return reps[item]
    }
        return " no"
        }
  
    
    func completeSet(_slider: CircularSlider){
        let weightIndex = pickerView.selectedItem
        let logWeight = Int(weights[weightIndex])!
        print(logWeight)
        let repIndex = pickerView1.selectedItem
        let logReps = Int(reps[repIndex])!
        print(logReps)
        
        let record = CKRecord(recordType: "SetData")
        record["exerciseName"] = self.workoutLabel.text! as CKRecordValue
        record["workoutName"] = self.sentName! as CKRecordValue
        record["reps"] = logReps as CKRecordValue
        record["weight"] = logWeight as CKRecordValue
        record["date"] = self.todaysDate as CKRecordValue
        record["instanceID"] = self.instanceID as CKRecordValue
        
        
        self.logData.append(record)
         updateSet()
    }
    
          
    func updateSet()
    {
        self.currentSet += 1
        
        let percent = self.currentSet / self.setTotal
        
        self.progressBar.progress = CGFloat( percent)
        if(self.currentSet == self.setTotal){
            performSegue(withIdentifier: "finish", sender: self)
        }

         if(self.currentSet != self.setTotal){
        var tempSet = Int( self.sets[self.setLabelCount])
        tempSet = tempSet! - 1
        let tempString = String(describing: tempSet!)
        if( tempSet != 0){
            
            
            self.sets[self.setLabelCount] = tempString
            self.setLabel.layer.add(self.animation, forKey: nil)
            self.setLabel.text = tempString
            
            
        }
        if(tempSet == 0){
            self.setLabel.layer.add(self.animation, forKey: nil)
            self.setLabel.text = sets[setLabelCount + 1]
            self.setLabelCount += 1
            self.workoutLabel.layer.add(self.animation, forKey: nil)
            self.workoutLabel.text = exerciseNames[workoutLabelCount + 1]
            self.workoutLabelCount += 1
            
        }
        }
          }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "finish" {
            let destVC = segue.destination as! SaveWorkoutViewController
            destVC.logData = self.logData
            destVC.instanceID = self.instanceID
            destVC.todaysDate = self.todaysDate
    }
    }
    func fixUpDisplay(){
        pickerView.tag = 1
        pickerView1.tag = 2
        // init slider view
        
        let frame = CGRect(x: 0, y: 0, width: sliderView.frame.width, height: sliderView.frame.height)
        self.circularSlider = CircularSlider(frame: frame)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView1.delegate = self
        pickerView1.dataSource = self
        
        pickerView.interitemSpacing = 40.0
        pickerView.font = UIFont(name: "Avenir-Light", size: 40.0)!
        pickerView.highlightedFont  = UIFont(name: "Avenir-Light", size: 40.0)!
        pickerView.textColor = UIColor.black
        pickerView.highlightedTextColor = UIColor.white
        
        pickerView1.interitemSpacing = 40.0
        pickerView1.font = UIFont(name: "Avenir-Light", size: 40.0)!
        pickerView1.highlightedFont  = UIFont(name: "Avenir-Light", size: 40.0)!
        pickerView1.textColor = UIColor.black
        pickerView1.highlightedTextColor = UIColor.white
        
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromTop
        animation.duration = 0.5
        
        workoutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        workoutAnimation.type = kCATransitionFade
        //workoutAnimation.subtype = kCATransi
        workoutAnimation.duration = 0.5
        
        self.pickerView.reloadData()
        self.pickerView1.reloadData()
        setLabel.text = sets[setLabelCount]
        // setup target to watch for value change
        
        circularSlider.addTarget(self, action: #selector(CircleSliderViewController.completeSet(_slider:)), for: UIControlEvents.primaryActionTriggered)
        circularSlider.circularSliderHandle.contents = UIImage(named: "print.png")?.cgImage
        // setup slider defaults
        circularSlider.handleType = .custom
        circularSlider.currentValue = 0
        circularSlider.lineWidth = 7
        workoutLabel.text = exerciseNames.first!
        
        // add to view
        sliderView.addSubview(circularSlider)
        //   sliderView.addGestureRecognizer(recognizer)
        
//     progressBar.type = YLProgressBarType.flat
//       progressBar.progressTintColor = UIColor.blue
//        progressBar.hideStripes = true
//        // Green rounded/gloss progress, with vertical animated stripes in the left direction
       progressBar.type = YLProgressBarType.rounded
//        progressBar.progressTintColor = UIColor.green
       progressBar.stripesOrientation = YLProgressBarStripesOrientation.vertical
        progressBar.stripesDirection = YLProgressBarStripesDirection.left
        
      let rainbowColors: [UIColor] = [UIColor(red: 33 / 255.0, green: 180 / 255.0, blue: 162 / 255.0, alpha: 1.0), UIColor(red: 3 / 255.0, green: 137 / 255.0, blue: 166 / 255.0, alpha: 1.0), UIColor(red: 91 / 255.0, green: 63 / 255.0, blue: 150 / 255.0, alpha: 1.0), UIColor(red: 87 / 255.0, green: 26 / 255.0, blue: 70 / 255.0, alpha: 1.0), UIColor(red: 126 / 255.0, green: 26 / 255.0, blue: 36 / 255.0, alpha: 1.0), UIColor(red: 149 / 255.0, green: 37 / 255.0, blue: 36 / 255.0, alpha: 1.0), UIColor(red: 228 / 255.0, green: 69 / 255.0, blue: 39 / 255.0, alpha: 1.0), UIColor(red: 245 / 255.0, green: 166 / 255.0, blue: 35 / 255.0, alpha: 1.0), UIColor(red: 165 / 255.0, green: 202 / 255.0, blue: 60 / 255.0, alpha: 1.0), UIColor(red: 202 / 255.0, green: 217 / 255.0, blue: 54 / 255.0, alpha: 1.0), UIColor(red: 111 / 255.0, green: 188 / 255.0, blue: 84 / 255.0, alpha: 1.0)]
        
      // self.progressBar.hideStripes = true
     
        progressBar.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayMode.progress
        progressBar.progressTintColors = rainbowColors
        // To allow the gradient colors to fit the progress width
        progressBar.progressStretch = true
        progressBar.progress = 0
        progressBar.indicatorTextLabel.font = UIFont(name: "Avenir", size: 12.0)
        progressBar.backgroundColor = UIColor.clear
       


    }
}

