//
//  ExercisesViewController.swift
//  fitspire
//
//  Created by LUNVCA on 7/21/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit

class ExercisesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
let reuseIdentifier = "cell"
var bodyParts = ["Chest", "Biceps", "Quads","Abs","Calves", "Triceps", "Upper Back","Lower Back","Shoulders", "Hamstrings/Glutes", "Traps", "Forearms"]
    var names = ["chest.png","biceps.png","quads.png","abs.png", "calves.png","triceps.png","back.png","lowerback.png","deltoid.png","glutes.png","traps.png","forearm.png"]
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
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bodyParts.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! BodyPartCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = self.bodyParts[indexPath.item]
        cell.myLabel.textColor = UIColor.white
        cell.partImage.image = UIImage(named: self.names[indexPath.row])
    
       // cell.featuredImage.image = UIImage(named: imageNames[indexPath.item])
        
        // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
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
