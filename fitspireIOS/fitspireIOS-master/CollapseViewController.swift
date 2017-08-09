//
//  ViewController.swift
//  ios-swift-collapsible-table-section-in-grouped-section
//
//  Created by Yong Su on 5/31/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit
import CloudKit

class CollapseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //
    // MARK: - Data
    @IBOutlet var tableView : UITableView!
    @IBOutlet var exerciseImage: UIImageView!
    @IBOutlet var exerciseLabel : UILabel!
    @IBOutlet var background : UIImageView!
    struct Section {
        var name: String = ""
        var items: [String] = []
        var collapsed: Bool!
        
        init(name: String, items: [String], collapsed: Bool = true) {
            self.name = name
            self.items = items
            self.collapsed = collapsed
        }
    }
    var exerciseData : CKRecord!
    var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        //first get all of the values for the display
        let photo =
            exerciseData.object(forKey: "Image") as! CKAsset
        
        let image = UIImage(contentsOfFile:
            photo.fileURL.path)
        
        self.exerciseImage.image = image
        let exerciseName = exerciseData.value(forKey: "exerciseName") as! String
        let type = exerciseData.value(forKey: "Type") as! String
        let equipment = exerciseData.value(forKey: "equipmentType") as! String
        let muscle1 = exerciseData.value(forKey: "muscle1") as! String
        let muscle2 = exerciseData.value(forKey: "muscle2") as! String?
        let muscle3 = exerciseData.value(forKey: "muscle3") as! String?
        let muscle4 = exerciseData.value(forKey: "muscle4") as! String?
        let difficulty = exerciseData.value(forKey: "difficulty")as! String
        let steps = exerciseData.value(forKey: "steps") as! [String]
        let tips = exerciseData.value(forKey: "tips") as! [String]?
        
        exerciseLabel.text = exerciseName
        self.tableView.backgroundColor = UIColor.clear;
        self.tableView.isOpaque = false;
        sections.append( Section(name: "EXERCISE TYPE" , items: [type]))
        if( muscle4 == nil && muscle3 == nil && muscle2 == nil){
         sections.append(Section(name: "MUSCLES TARGETED", items: [muscle1]))
        
        }
        if( muscle4 == nil && muscle3 == nil && muscle2 != nil){
            sections.append(Section(name: "MUSCLES TARGETED", items: [muscle1, muscle2!]))
            
            
        }
        if(  muscle4 == nil && muscle3 != nil && muscle2 != nil){
            sections.append(Section(name: "MUSCLES TARGETED", items: [muscle1, muscle2!, muscle3!]))
            
        }
        if(  muscle4 != nil && muscle3 != nil && muscle2 != nil){
            sections.append(Section(name: "MUSCLES TARGETED", items: [muscle1, muscle2!, muscle3!, muscle4!]))
            
        }


        
        sections.append(  Section(name: "EQUIPMENT USED", items: [equipment]))
        sections.append( Section( name: "DIFFICULTY", items: [difficulty]))
        sections.append( Section(name: "STEPS", items: steps))
        if( tips != nil){
        sections.append( Section(name: "TIPS", items: tips!))
        }
       
     
          }

    override func viewWillAppear(_ animated: Bool) {
        if let savedValue = UserDefaults.standard.string(forKey: "backgroundName") {
            var image = UIImage(named: savedValue)
            background.image = image
        }
        
    }
    // MARK: - Table view delegate
    //
    
func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            
            case 0:  return "Exercise Info"
            default: return ""
        }
    }

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        
        // For section 1, the total count is items count plus the number of headers
        var count = sections.count
        
        for section in sections {
            count += section.items.count
        }
        
        return count
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.white
        }
    }
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        
        // Calculate the real section index and row index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        // Header has fixed height
        if row == 0 {
            return 50.0
        }
        
        return sections[section].collapsed! ? 0 : 44.0
    }
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        // Calculate the real section index and row index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! HeaderCell
            cell.titleLabel.text = sections[section].name
            cell.toggleButton.tag = section
            if(sections[section].collapsed!){
                cell.collapseLabel.text =  "+"
            }
            if(sections[section].collapsed! != true){
                cell.collapseLabel.text = "-"
            }
            cell.toggleButton.addTarget(self, action: #selector(self.toggleCollapse), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
            cell?.textLabel?.text = sections[section].items[row - 1]
            return cell!
        }
    }
    
    //
    // MARK: - Event Handlers
    //
    func toggleCollapse(_ sender: UIButton) {
        let section = sender.tag
        let collapsed = sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = !collapsed!
        
        let indices = getHeaderIndices()
        
        let start = indices[section]
        let end = start + sections[section].items.count
        
        tableView.beginUpdates()
        for i in start ..< end + 1 {
            tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    //
    // MARK: - Helper Functions
    //
    func getSectionIndex(_ row: NSInteger) -> Int {
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                return i
            }
        }
        
        return -1
    }
    
    func getRowIndex(_ row: NSInteger) -> Int {
        var index = row
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                index -= indices[i]
                break
            }
        }
        
        return index
    }
    
    func getHeaderIndices() -> [Int] {
        var index = 0
        var indices: [Int] = []
        
        for section in sections {
            indices.append(index)
            index += section.items.count + 1
        }
        
        return indices
    }

}
