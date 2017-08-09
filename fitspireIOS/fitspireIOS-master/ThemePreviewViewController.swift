//
//  ThemePreviewViewController.swift
//  fitspire
//
//  Created by LUNVCA on 8/8/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit

class ThemePreviewViewController: UIViewController {
    @IBOutlet var background : UIImageView!
    @IBOutlet var previewView: UIView!
    var picName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var image = UIImage(named: picName)
        self.background.image = image
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func buttonPressed(sender: UIButton){
        let valueToSave = picName
        UserDefaults.standard.set(valueToSave, forKey: "backgroundName")
        
         _ = navigationController?.popViewController(animated: true)
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
