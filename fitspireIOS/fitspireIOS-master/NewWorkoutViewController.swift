//
//  NewWorkoutViewController.swift
//  fitspire
//
//  Created by LUNVCA on 8/2/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData

class NewWorkoutViewController: UIViewController, UITextFieldDelegate, AKPickerViewDelegate, AKPickerViewDataSource, UITextViewDelegate {
    @IBOutlet var viewForm : UIView!
    @IBOutlet var imageUpload : UIView!
    @IBOutlet var musclePickerView : AKPickerView!
    @IBOutlet var typePickerView: AKPickerView!
    @IBOutlet var xpPickerView : AKPickerView!
    @IBOutlet var nameTextField : UITextField!
    @IBOutlet var descTextView : UITextView!
    @IBOutlet var createButton : UIButton!
    @IBOutlet var plusLabel : UILabel!
    @IBOutlet var background: UIImageView!
    var muscles : [String] = ["---          " ,"Upper Body", "Lower Body", "Full Body", "Core", "Chest", "Biceps", "Quads","Abs","Calves", "Triceps", "Upper Back","Lower Back","Shoulders", "Hamstrings/Glutes", "Traps", "Forearms"]
    var type : [String] = ["---          ","Strength", "Cardio", "Yoga", "Stretch"]
    var xp : [String]  = ["---           ","Beginner", "Intermediate", "Expert"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        viewForm.layer.borderWidth = 2
        viewForm.layer.borderColor = UIColor.white.cgColor
        viewForm.layer.cornerRadius = 8.0
        imageUpload.layer.borderWidth = 2
         imageUpload.layer.borderColor = UIColor.white.cgColor
        nameTextField.textColor = UIColor.white
        createButton.layer.borderWidth = 1
        createButton.layer.borderColor = UIColor.white.cgColor
        createButton.layer.cornerRadius = 8.0
        createButton.alpha = 0.5
        plusLabel.alpha = 0.5
        createButton.isEnabled = false
        musclePickerView.delegate = self
        musclePickerView.dataSource = self
        typePickerView.delegate = self
        typePickerView.dataSource = self
        xpPickerView.delegate = self
        xpPickerView.dataSource = self
        musclePickerView.tag = 1
          typePickerView.tag = 2
          xpPickerView.tag = 3
        nameTextField.delegate = self
        descTextView.delegate = self
        musclePickerView.interitemSpacing = 20.0
        musclePickerView.font = UIFont(name: "Avenir-Light", size: 20.0)!
        musclePickerView.highlightedFont  = UIFont(name: "Avenir-Light", size: 20.0)!
        musclePickerView.textColor = UIColor.white
        musclePickerView.highlightedTextColor = UIColor.green
        
        typePickerView.interitemSpacing = 20.0
        typePickerView.font = UIFont(name: "Avenir-Light", size: 20.0)!
        typePickerView.highlightedFont  = UIFont(name: "Avenir-Light", size: 20.0)!
        typePickerView.textColor = UIColor.white
        typePickerView.highlightedTextColor = UIColor.green
        
        xpPickerView.interitemSpacing = 20.0
        xpPickerView.font = UIFont(name: "Avenir-Light", size: 20.0)!
        xpPickerView.highlightedFont  = UIFont(name: "Avenir-Light", size: 20.0)!
        xpPickerView.textColor = UIColor.white
        xpPickerView.highlightedTextColor = UIColor.green

        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if let savedValue = UserDefaults.standard.string(forKey: "backgroundName") {
            var image = UIImage(named: savedValue)
            background.image = image
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textFieldShouldReturn(nameTextField)
        self.textViewShouldReturn(descTextView)
    }
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int
    {
        if(pickerView.tag == 1){
            return muscles.count
        }
        if(pickerView.tag == 2){
            return type.count
        }
        if(pickerView.tag == 3){
            return xp.count
        }

        return 0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.endEditing(true)
        return true
    }
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.endEditing(true)
        return true
    }
    @IBAction func textFieldDidEndEditing(_ textField: UITextField) {
        if nameTextField.text != "" {
            createButton.alpha = 1
            plusLabel.alpha = 1
            createButton.isEnabled = true
        }
    }
    
    func save() {
        let name = nameTextField.text!
        
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
           _ = navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    

func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.text == "Description" {
         
            textView.text = nil
          
        }
    }
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        if(pickerView.tag == 1){
            return muscles[item]
        }
        if(pickerView.tag == 2){
            return type[item]
        }
        if(pickerView.tag == 3){
            return xp[item]
        }

        return " no"
    }
    
    
    @IBAction func buttonPressed(sender: UIButton)
    {
   self.save()
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
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}
