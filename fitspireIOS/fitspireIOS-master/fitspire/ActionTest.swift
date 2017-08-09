//
//  ViewController.swift
//  YNActionSheetDemo
//
//  Created by 游义男 on 15/10/16.
//  Copyright (c) 2015年 游义男. All rights reserved.
//

import UIKit

class ActionTest: UIViewController,YNActionSheetDelegate {

    @IBAction func actionSheetBtnTapped(_ sender: AnyObject) {
       displayAction()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAction(){
        var action = YNActionSheet()
        action.delegate = self
        action.addCancelButtonWithTitle("CancelTitle")
        action.addButtonWithTitle("title1")
        action.addButtonWithTitle("title2")
        action.addButtonWithTitle("title3")
        self.present(action, animated: true) { () -> Void in
            
        }
    }
    func buttonClick(_ index: Int) {
        print("\(index)")
    }

}

