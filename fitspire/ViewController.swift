//
//  ViewController.swift
//  fitspire
//
//  Created by LUNVCA on 1/17/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewController: UITableViewController {

    private let kTableHeaderHeight : CGFloat = 300.0
    var headerView : UIView!
    @IBOutlet var profileImage : UIImageView!
    @IBOutlet var segmentControl : customSegment!
  var thisweek =  [Date]()
  var item = [SplitItem]()
  var index = 0
  let dateFormatter = DateFormatter()
    var dateBack = [Date]()
    var dates : [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named:"linked.jpg")
        self.profileImage.maskCircle(anyImage: image!)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest1 = NSFetchRequest<NSManagedObject>(entityName: "Meta")
        do {
            dates = try managedContext.fetch(fetchRequest1)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

       
        for index in 0 ... 6 {
        var components = DateComponents()
        components.setValue(index, for: .day)
        let date: Date = Date()
        let dayfill = Calendar.current.date(byAdding: components, to: date)!
        thisweek.append(dayfill)
     
            
        
        }
        index = 0
        for (index, _) in thisweek.enumerated() {
            
            let thisDate = thisweek[index]
            self.dateFormatter.dateFormat = " YYYY EEEE, MMM dd"
            let somedateString = dateFormatter.string(from: thisDate)
            
            let dateValue = dateFormatter.date(from: somedateString) as Date!
            dateBack.append(dateValue!)
            
            self.dateFormatter.dateFormat = "EEEE, MMMM dd"
            let cellDate = dateFormatter.string(from:thisDate)
            
            let placeholder = UIImage(named: "rest1.jpg")
            let initSplit = SplitItem(day: cellDate, summary: "REST DAY", image: placeholder)
            item.append(initSplit)
        }

    
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0 , y: -kTableHeaderHeight)
        updateHeaderView()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var dateMatch : [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        for i in 0 ... self.dateBack.count - 1{
        let managedContext = appDelegate.persistentContainer.viewContext
        print(dateBack[i])
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Meta")
        fetchRequest.predicate = NSPredicate(format: "workoutDate == %@", dateBack[i] as CVarArg)
        
        do {
            dateMatch = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
           
            if(dateMatch.count == 0)
            {
                save(date: dateBack[i])
                print("saved a date! \(dateBack[i])")
            }
        }
        self.tableView.reloadData()
           }

    func save(date: Date)
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1 first get context
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2 then get entity
        let entity =
            NSEntityDescription.entity(forEntityName: "Meta",
                                       in: managedContext)!
        
        let newDate = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
        
        // 3
        newDate.setValue(date, forKeyPath: "workoutDate")
        
        // 4
        do {
            try managedContext.save()
           
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    
        // Do any additional setup after loading the view, typically from a nib.
    
    func updateHeaderView(){
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight )
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
            
        }
        headerView.frame = headerRect
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let items = item[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ScheduleItemCell
        cell.SplitItem = items
        cell.layoutMargins = UIEdgeInsets.zero
        
        if(dates.count > 0){
        let dataDate = dates[indexPath.row]
        let maybeWorkout = dataDate.value(forKey: "workoutName") as! String?

        if (maybeWorkout != nil) {
            cell.Description.text = maybeWorkout!
            cell.Pic.image = UIImage(named: "liftDay.png")
        }
        }
        
        
        return cell
    }
        
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    
    
    // MARK: - UITableViewDelegate
   
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
}

