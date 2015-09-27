//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Anvisha Pai on 9/26/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters:[String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var filtersTableView: UITableView!
    var categories: [[String:String]]!
    var dealState = false
    var switchStates = [Int:Bool]()
    var sortState = 0
    var distanceState = 0 //[0.3, 1, 5,
    var distanceExpanded = false
    let distances = ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"]
    let distancesAbsolute = [0, 0.3*1609.34, 1*1609.34, 5*1609.34, 20*1609.34]
    weak var delegate: FiltersViewControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersTableView.dataSource = self
        filtersTableView.delegate = self
        categories = yelpCategories()
    }
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String : AnyObject]()
        var selectedCategories = [String]()
        for (row , isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        filters["deals"] = dealState
        filters["radius"] = distancesAbsolute[distanceState]
        filters["sort"] = sortState != 0 ? sortState : nil
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }

    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func yelpCategories() -> [[String:String]] {
        return yelpConstantCategories
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
            case 0:
                return 1
            case 1:
                return distanceExpanded ? 5 : 1
            case 2:
                return 1
            case 3:
                return categories.count
            default:
                return 0
        
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch(indexPath.section){
        
        case 0:
            let cell = filtersTableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.switchLabel.text = "Offering a Deal"
            cell.delegate = self
            cell.onSwitch.on = dealState
            return cell
        
        case 1:
            let cell = filtersTableView.dequeueReusableCellWithIdentifier("DropdownCell", forIndexPath: indexPath) as! DropdownCell
            let distanceIndex = distanceExpanded ? indexPath.row : distanceState
            cell.dropdownLabel.text = distances[distanceIndex]
            return cell
            
        default:
            let cell = filtersTableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            cell.onSwitch.on = switchStates[indexPath.row] ?? false
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfSectionsInTableView section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section){
        case 0:
            return nil
        case 1:
            return "Distance"
        case 2:
            return "Sort By"
        case 3:
            return "Category"
        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            distanceState = indexPath.row
            print(distanceState)
            expandDistanceCell()
        } else if indexPath.section == 2 {
        }
    }
    
    func expandDistanceCell() {
        var indexPaths = [NSIndexPath]()
        for i in  1...4 {
            indexPaths.append(NSIndexPath(forRow: i, inSection: 1))
        }
        if distanceExpanded == true {
            distanceExpanded = false
            filtersTableView.beginUpdates()
            filtersTableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Bottom)
            filtersTableView.endUpdates()
        }
        else {
            distanceExpanded = true
            filtersTableView.beginUpdates()
            filtersTableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Bottom)
            filtersTableView.endUpdates()
        }
        filtersTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Fade)
    }

    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = filtersTableView.indexPathForCell(switchCell)
        if indexPath?.section == 0 {
            dealState = value
        } else {
        switchStates[(indexPath?.row)!] = value
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
