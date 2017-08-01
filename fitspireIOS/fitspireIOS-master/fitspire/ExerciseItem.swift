//
//  ExerciseItem.swift
//  fitspire
//
//  Created by LUNVCA on 7/20/17.
//  Copyright © 2017 uca. All rights reserved.
//

import Foundation
import UIKit

struct ExerciseItem{
    
    var exerciseName : String
    var exerciseDesc: String
    var muscleWorked : [String]
    var bodyWeightFlag = 0
    var image : UIImage
    
    init(name: String, desc: String, worked: [String], flag: Int, image: String ){
        
        self.exerciseName = name
        self.exerciseDesc = desc
        self.muscleWorked = worked
        self.bodyWeightFlag = flag
        self.image = UIImage(named: image)!
        
        
    }
    
}
