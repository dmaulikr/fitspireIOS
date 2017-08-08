//
//  NoteView.swift
//  fitspire
//
//  Created by LUNVCA on 8/2/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit

@IBDesignable  class NoteView: UIView {
    

    @IBOutlet var closeButton : UIButton!
    @IBOutlet var saveButton : UIButton!
    @IBOutlet var noteText : UITextView!
    
  
    @IBAction func closeButtonPressed (sender: UIButton){
        
        print("close Button Pressed")
    }
    @IBAction func confirmButtonPressed (sender: UIButton){
        print("confirm Button Pressed")
    }
}

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


