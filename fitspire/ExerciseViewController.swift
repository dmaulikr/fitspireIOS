//
//  ExerciseViewController.swift
//  fitspire
//
//  Created by LUNVCA on 7/20/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {

    let exerciseData = [ExerciseItem(name: "Chest Flies", desc: "Opening Arms to Build Chest", worked: ["Chest" , "Deltoids"], flag: 0, image: "chestflies.png"), ExerciseItem(name: "Barbell Bench Press", desc: "Laying on Bench and Pressing a Barbell", worked: ["Chest" ], flag: 0, image: "barbellbenchpress.png"),ExerciseItem(name: "Tricep Dips", desc: "Opening Arms to Build Chest", worked: ["Chest" , "Triceps"], flag: 0,image: "tricepdips.png")]
    var exerciseNames =  [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    
       
        for i in  0 ... exerciseData.count{
           exerciseNames[i] = exerciseData[i].exerciseName
        }
        
   
    }



}
extension ExerciseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return exerciseNames.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath)
            cell.textLabel?.text = exerciseNames[indexPath.row]
            return cell
    }

}

