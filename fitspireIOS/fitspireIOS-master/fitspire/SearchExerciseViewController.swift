//
//  SearchExerciseViewController.swift
//  fitspire
//
//  Created by LUNVCA on 7/20/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit
import CloudKit
import QuartzCore
import CoreData

class SearchExerciseViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UISearchBarDelegate {
    let reuseIdentifier = "cell"
    @IBOutlet var collection : UICollectionView!
    var exerciseNames  : [String] = []
    var exerciseImages : [UIImage] = []
    var addingIndex = 0
    var exer : [CKRecord] = []
    var workouts: [NSManagedObject] = []
    @IBOutlet var searchBar : UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        
        
        
        // Do any additional setup after loading the view.
    }
    func setupSearchBar() {
        
        
        searchBar.delegate = self
        searchBar.barTintColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1)
        searchBar.backgroundColor = UIColor.blue
        searchBar.isTranslucent = true
        searchBar.placeholder = "Search Timeline"
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Workouts")
        do {
            workouts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchExercises(searchPredicate: searchText)
        print("search changed")
    }
    
    
    func fetchExercises(searchPredicate: String) {
        let container = CKContainer.default()
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(format: "self CONTAINS %@", searchPredicate)
        
        let query = CKQuery(recordType: "Exercises", predicate: predicate)
        
        
        publicDatabase.perform(query, inZoneWith: nil) { (results, error) -> Void in
            
            if error != nil {
                
                print("error fetch notes \(String(describing: error))")
                
            } else {
                
                print("Success")
                
                for result in results! {
                    self.exer.append(result )
                }
                
                OperationQueue.main.addOperation({ () -> Void in
                    self.collection.reloadData()
                    self.collection.isHidden = false
                })
            }
        }
    }
    
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.exer.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ExerciseCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        let eRecord: CKRecord = exer[indexPath.row]
        
        cell.myLabel.text = eRecord.value(forKey: "exerciseName") as? String
        
        let photo =
            eRecord.object(forKey: "Image") as! CKAsset
        
        let image = UIImage(contentsOfFile:
            photo.fileURL.path)
        
        cell.exerciseImage.image = image
        
        
        
        
        
        cell.layer.cornerRadius = 2.0
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
        print("You selected cell #\(indexPath.item)!")
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowExercise" {
            
            
            
            let detailsVC = segue.destination as! CollapseViewController
            let cell = sender as! ExerciseCollectionViewCell
            let indexPaths = self.collection.indexPath(for: cell)
            
            let thisExercise = self.exer[indexPaths!.row]
            
            
            detailsVC.exerciseData = thisExercise
            
            
            
        }
        
    }
    
    
    @IBAction func show(sender: UIButton) {
        
        
        let actionSheet = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor.green
        if let cell = sender.superview?.superview as? ExerciseCollectionViewCell {
            let indexPath = collection.indexPath(for: cell)
            
            self.addingIndex = (indexPath?.row)!
        }
        
        let view = UIView(frame: CGRect(x: 8.0, y: 8.0, width: actionSheet.view.bounds.size.width - 8.0 * 4.5, height: 120.0))
        view.backgroundColor = UIColor(colorLiteralRed: 0, green: 110.0/255, blue: 0, alpha: 0.5)
        actionSheet.view.addSubview(view)
        
        actionSheet.addAction(UIAlertAction(title: "Add to Workout", style: .default, handler: { action in self.chooseWorkout() }))
        actionSheet.addAction(UIAlertAction(title: "Add to New Workout", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Add To Favorites", style: .default, handler: nil))
        
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func chooseWorkout(){
        let actionSheet = UIAlertController(title: "Add Exercise To: ", message: nil, preferredStyle: .actionSheet)
        for i in 0...workouts.count - 1{
            let workoutName = workouts[i].value(forKeyPath: "workoutName") as! String
            actionSheet.addAction(UIAlertAction(title: workoutName, style: .default, handler: {action in self.saveExercise(workoutName: workoutName)}))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
        
    }
    func saveExercise(workoutName: String){
        let ck = exer[addingIndex]
        let eName = ck.value(forKey: "exerciseName") as! String
        let m1 = ck.value(forKey: "muscle1") as! String
        let m2 = ck.value(forKey: "muscle2") as? String
        let m3 = ck.value(forKey: "muscle3") as? String
        let m4 = ck.value(forKey: "muscle4") as? String
        let eUsed = ck.value(forKey: "equipmentType") as! String
        let diff = ck.value(forKey: "difficulty") as! String
        let bw = ck.value(forKey: "bodyweightFlag") as! Int
        let creation = NSDate()
        
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1 first get context
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2 then get entity
        let entity =
            NSEntityDescription.entity(forEntityName: "Exercises",
                                       in: managedContext)!
        
        let exerciseIn = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
        
        
        
        // 3
        exerciseIn.setValue(workoutName, forKeyPath: "workoutName")
        exerciseIn.setValue(eName, forKey: "exerciseName")
        exerciseIn.setValue(m1, forKeyPath: "muscle1")
        exerciseIn.setValue(m2, forKeyPath: "muscle2")
        exerciseIn.setValue(m3, forKeyPath: "muscle3")
        exerciseIn.setValue(m4 , forKeyPath: "muscle4")
        exerciseIn.setValue(eUsed, forKeyPath: "equipmentType")
        exerciseIn.setValue(bw, forKey: "bodyweightFlag")
        exerciseIn.setValue(diff, forKey: "difficulty")
        exerciseIn.setValue(creation, forKey: "creation")
        exerciseIn.setValue( "3" , forKey: "setCount")
        
        do {
            try managedContext.save()
            print("Success")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
