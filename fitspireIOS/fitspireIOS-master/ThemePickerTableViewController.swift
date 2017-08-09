//
//  ThemePickerTableViewController.swift
//  fitspire
//
//  Created by LUNVCA on 8/8/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit

class ThemePickerTableViewController: UITableViewController {

    @IBOutlet var workoutLabel : UILabel!
    @IBOutlet weak var themeTableView: UITableView!
   let themeImageNames = ["Vine.png", "Tranquil.png","Sweet Morning.png", "Red Ocean.png", "Radar.png", "Purple White.png", "Poncho.png", "Netflix.png", "Lizard.png","Grapefruit Sunset.png", "Frost.png", "Ed's Sunset Gradient.png", "Dusk.png", "Disco.png", "Deep Space.png" , "Decent.png", "Brady Brady Fun Fun.png", "50 Shades of Grey.png"]
    let themeNames = ["Vine", "Tranquil","Sweet Morning", "Red Ocean", "Radar", "Purple White", "Poncho", "Netflix", "Lizard","Grapefruit Sunset", "Frost", "Ed's Sunset Gradient", "Dusk", "Disco", "Deep Space" , "Decent", "Brady Brady Fun Fun", "50 Shades of Grey"]
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        }
    
    



    override func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return themeNames.count
    }
    
   override func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
           
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath) as! WorkoutTableViewCell
           cell.workoutLabel.text = themeNames[indexPath.row]
           cell.workoutPic.image = UIImage(named: themeImageNames[indexPath.row])
            return cell
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPreview" {
            
            
            
            let detailsVC = segue.destination as! ThemePreviewViewController
            let cell = sender as! WorkoutTableViewCell
            let indexPaths = self.tableView.indexPath(for: cell)
            
            let thisImageName = self.themeImageNames[indexPaths!.row]
            
            
            detailsVC.picName = thisImageName
            
            
            
        }
        
    }

}
