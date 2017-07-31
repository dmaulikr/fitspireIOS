//
//  CircularSliderHandle.swift
//
//  Created by Christopher Olsen on 03/03/16.
//  Copyright © 2016 Christopher Olsen. All rights reserved.
//

import UIKit

class CircularSliderHandle: CALayer {
  var highlighted = false

    override init(){
        super.init()
        self.contents = contents = UIImage(named: "print")?.cgImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

