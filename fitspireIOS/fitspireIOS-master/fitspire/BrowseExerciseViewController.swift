//
//  BrowseExerciseViewController.swift
//  fitspire
//
//  Created by LUNVCA on 8/8/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit

class BrowseExerciseViewController: UIViewController {
    @IBOutlet var background : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if let savedValue = UserDefaults.standard.string(forKey: "backgroundName") {
            var image = UIImage(named: savedValue)
            background.image = image
        }
        
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
