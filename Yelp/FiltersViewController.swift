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
    weak var delegate: FiltersViewControllerDelegate?
    
//    let allFilters = ["deal", ("distance", ["Auto", "0.3 miles", "1 miles", "5 miles", "20 miles"]), ("sort_by", ["Best Match"]),
    
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
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }

    @IBAction func onCancelButton(sender: AnyObject) {
        print("hi")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func yelpCategories() -> [[String:String]] {
        return yelpConstantCategories
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 3 {
            return 1
        } else {
            return categories.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch(indexPath.section){
        
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.switchLabel.text = "Offering a Deal"
            cell.delegate = self
            cell.onSwitch.on = dealState
            return cell
        
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            
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
