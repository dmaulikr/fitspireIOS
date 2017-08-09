//
//  BuildViewController.swift
//  fitspire
//
//  Created by LUNVCA on 7/21/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit
import QuartzCore

class BuildViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate {
 let reuseIdentifier = "cell"
   @IBOutlet var featured : UICollectionView!
    var workoutNames  : [String] = ["Arnold's Busting Biceps", "Tony Hortons AB Ripper X",  " Hulk Hogans Butt Blaster"]
    var imageNames : [String] = ["asback.jpg","tonyHorton.jpg","hulk mania.jpg"]
   @IBOutlet var backView : UILabel!
   @IBOutlet var backView2 : UILabel!
    @IBOutlet var background : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        featured.backgroundColor = UIColor.clear
        backView.layer.cornerRadius = 5.0
        backView2.layer.cornerRadius = 10.0
        backView.layer.masksToBounds = true
         backView2.layer.masksToBounds = true
        backView.layer.shadowOffset = CGSize(width: 20, height: 10)
        backView2.layer.shadowOffset = CGSize(width: 20, height: 10)
        // Do any additional setup after loading the view.
      

    }
    override func viewWillAppear(_ animated: Bool) {
        if let savedValue = UserDefaults.standard.string(forKey: "backgroundName") {
            var image = UIImage(named: savedValue)
            background.image = image
        }

    }
  
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.workoutNames.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! FeaturedCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = self.workoutNames[indexPath.item]
        
        cell.featuredImage.image = UIImage(named: imageNames[indexPath.item])
        
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
