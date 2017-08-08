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
    @IBOutlet var noteButton: UIButton!
    var lastSliderVal : Float = 0.0
    var weights : [String] = []
    var reps : [String] = []
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
    var setCounter = 0
    var noteView : NoteView!
    var noteText : String = ""
    var upView : UIView?
    var downView: UIView?
   @IBOutlet var dotCircle : UIImageView!
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    var sliderDiff : CGFloat = 0.0
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    for index in 1...60 {
        let rep = String(index)
        reps.append(rep)
    }
    for index in 1...50 {
        let weight = String(index * 5)
        weights.append(weight)
        
    }
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
    generator.prepare()
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
   
    @IBAction func noteButtonPressed(sender: UIButton){
        print("buttonPressed")
        let noteFrame = CGRect(x: (super.view.frame.width - 330)/2, y: super.view.frame.width - 200, width: 330, height: 200)
       self.noteView = Bundle.main.loadNibNamed("NoteView", owner: self, options: nil)?.first as? NoteView
        noteView.frame = noteFrame
        self.noteView.closeButton.addTarget(self, action: #selector(self.closeNoteView) , for: .touchUpInside)
         self.noteView.saveButton.addTarget(self, action: #selector(self.saveNoteView) , for: .touchUpInside)
        self.view.addSubview(noteView)
        
        
                }
    func saveNoteView(){
        self.noteText = self.noteView.noteText.text
     noteView.removeFromSuperview()
    }
    func closeNoteView (){
       noteView.removeFromSuperview()
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
        if(noteText != ""){
            record["notes"] = self.noteText as CKRecordValue
        }
        var indexSpot = Int(self.currentSet) + 1
        var setSpot = self.setCounter + 1
        
        record["index"] = indexSpot as CKRecordValue
       record["setCount"] = setSpot as CKRecordValue
        print("index was set to \(indexSpot)")
        print("setCount was set to \(setSpot)")
        
        
        self.logData.append(record)
         updateSet()
    }
    
    @IBAction func rotateImage() {
        var transform = self.dotCircle.transform.rotated(by: CGFloat(CGFloat(M_PI/2)/10));
        if(self.lastSliderVal != 0){
        self.sliderDiff = CGFloat(self.circularSlider.currentValue - self.lastSliderVal)
       print (sliderDiff)
        }
       
        if sliderDiff > 1.5{
         transform = self.dotCircle.transform.rotated(by: CGFloat(CGFloat(sliderDiff)/10));

        }
    
        self.dotCircle.transform = transform;
        self.lastSliderVal = self.circularSlider.currentValue

        
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
            
            self.setCounter += 1
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
            self.setCounter = 0
            
        }
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "finish" {
            let destVC = segue.destination as! SaveWorkoutViewController
            destVC.logData = self.logData
            destVC.instanceID = self.instanceID
            destVC.todaysDate = self.todaysDate
            destVC.workoutName = self.sentName
    }
          }
    func tapHandler(gesture: UITapGestureRecognizer) {
        let lastPoint = gesture.location(in: self.view)
        let picFrame = CGRect(x: 0, y: 0, width: 100, height: 50)

        // handle touch down and touch up events separately
        if gesture.state == .began {
            
            generator.impactOccurred()
                generator.prepare()
                      let upFrame =  CGRect(x: pickerView.frame.midX + 65   , y: pickerView.frame.midY + 190, width: 100, height: 50)
            
            self.upView = UIView(frame: upFrame)
           
         
            let backgroundImage = UIImageView(frame: picFrame)
               backgroundImage.alpha = 0.7
            backgroundImage.image = UIImage(named: "whiteup.png")
            self.upView!.addSubview(backgroundImage)
            let downFrame =  CGRect(x: pickerView.frame.midX + 65   , y: pickerView.frame.midY + 310 , width: 100, height: 50)
            
            self.downView = UIView(frame: downFrame)
            self.upView?.backgroundColor = UIColor.clear

            let backgroundImage1 = UIImageView(frame: picFrame)
            backgroundImage1.alpha = 0.3
            backgroundImage1.image = UIImage(named: "whitedown.png")
            self.downView!.addSubview(backgroundImage1)
            self.view.addSubview(upView!)
            self.view.addSubview(downView!)
        }
        else if gesture.state == .changed {
            if (upView!.frame.contains(lastPoint)){
                let backgroundImage = UIImageView(frame: picFrame)
                      backgroundImage.alpha = 0.7
                backgroundImage.image = UIImage(named: "greenup.png")
                self.upView!.addSubview(backgroundImage)

            }
            if (downView!.frame.contains(lastPoint)){
                let backgroundImage = UIImageView(frame: picFrame)
                      backgroundImage.alpha = 0.7
                backgroundImage.image = UIImage(named: "greendown.png")
                self.downView!.addSubview(backgroundImage)

            }
            if !(upView!.frame.contains(lastPoint)){
                let backgroundImage = UIImageView(frame: picFrame)
                      backgroundImage.alpha = 0.7
                backgroundImage.image = UIImage(named: "whiteup.png")
                self.upView!.addSubview(backgroundImage)

            }
            if !(downView!.frame.contains(lastPoint)){
                let backgroundImage = UIImageView(frame: picFrame)
                      backgroundImage.alpha = 0.7
                backgroundImage.image = UIImage(named: "whitedown.png")
                self.downView!.addSubview(backgroundImage)

            }

        }
        else if  gesture.state == .ended {
            upView!.removeFromSuperview()
            downView!.removeFromSuperview()
            
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
        circularSlider.addTarget(self, action: #selector(CircleSliderViewController.rotateImage), for: UIControlEvents.valueChanged)
        circularSlider.circularSliderHandle.contents = UIImage(named: "print.png")?.cgImage
        // setup slider defaults
        circularSlider.handleType = .custom
        circularSlider.currentValue = 0
        circularSlider.lineWidth = 7
        workoutLabel.text = exerciseNames.first!
        
        // add to view
        sliderView.addSubview(circularSlider)
        //   sliderView.addGestureRecognizer(recognizer)
        
       progressBar.type = YLProgressBarType.rounded
//        progressBar.progressTintColor = UIColor.green
       progressBar.stripesOrientation = YLProgressBarStripesOrientation.right
        progressBar.stripesDirection = YLProgressBarStripesDirection.left
        

        
      // self.progressBar.hideStripes = true
        let gradientColors = [UIColor.white, UIColor(red: 215/255, green: 255/255, blue: 255/255, alpha: 1.0),UIColor(red: 157/255, green: 255/255, blue: 255/255, alpha: 1.0), UIColor(red: 84/255, green: 255/255, blue: 255/255, alpha: 1.0), UIColor(red: 84/255, green: 255/255, blue: 220/255, alpha: 1.0), UIColor(red: 84/255, green: 255/255, blue: 197/255, alpha: 1.0), UIColor(red: 84/255, green: 255/255, blue: 154/255, alpha: 1.0), UIColor(red: 84/255, green: 255/255, blue: 117/255, alpha: 1.0), UIColor(red: 84/255, green: 255/255, blue: 85/255, alpha: 1.0), UIColor(red: 84/255, green: 255/255, blue: 30/255, alpha: 1.0), UIColor(red: 84/255, green: 255/255, blue: 0/255, alpha: 1.0)]
        progressBar.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayMode.progress
        progressBar.progressTintColors = gradientColors
        
        // To allow the gradient colors to fit the progress width
        progressBar.progressStretch = true
        progressBar.progress = 0
        progressBar.indicatorTextLabel.font = UIFont(name: "Avenir", size: 12.0)
        progressBar.indicatorTextLabel.textColor = UIColor.black
        progressBar.backgroundColor = UIColor.clear
       
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(self.tapHandler))
        tap.minimumPressDuration = 0.5
        pickerView.addGestureRecognizer(tap)

    }
}
