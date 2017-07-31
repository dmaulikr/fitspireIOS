//
//  DisplayExerciseViewController.swift
//  fitspire
//
//  Created by LUNVCA on 7/23/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit
import CloudKit
class DisplayExerciseViewController: UIViewController {
    var exercise : CKRecord!
    override func viewDidLoad() {
        super.viewDidLoad()
            print(exercise.value(forKey: "exerciseName")!)
        
        
        // Do any additional setup after loading the view.
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
