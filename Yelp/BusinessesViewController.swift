//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, FiltersViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var offset = 0
    var tableLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension //use what autolayout rules say
        tableView.estimatedRowHeight = 120
        
        let searchBar = UISearchBar()
        self.navigationItem.titleView = searchBar
        searchBar.showsCancelButton = false
        searchBar.delegate = self

//
//        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
//            self.businesses = businesses
//            self.filteredBusinesses = businesses
//            for business in businesses {
//                print(business.name!)
//                print(business.address!)
//            }
//            self.tableView.reloadData()
//        })

        Business.searchWithTerm("Restaurants", sort: .Distance, categories: nil, deals: false, radius: nil, offset: nil) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = businesses
//            if businesses != nil {
//                for business in businesses {
//                    print(business.name!)
//                    print(business.address!)
//                }}
            self.tableView.reloadData()
            self.tableLoaded = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredBusinesses != nil {
            return filteredBusinesses.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = filteredBusinesses[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if tableLoaded == true {
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if (maximumOffset - currentOffset) <= 10 {
                print("added")
                print(tableLoaded)
                tableLoaded = false
                Business.searchWithTerm("Restaurants", sort: .Distance, categories: nil, deals: false, radius: nil, offset: offset + 20) { (businesses: [Business]!, error: NSError!) -> Void in
                    if businesses != nil {
                        self.businesses.appendContentsOf(businesses)
                        self.filteredBusinesses.appendContentsOf(businesses)
                        print(businesses.count)
        //                if businesses != nil {
        //                    for business in businesses {
        //                        print(business.name!)
        //                        print(business.address!)
        //                    }}
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.filteredBusinesses.count {
            print ("end of list")
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        filteredBusinesses = businesses
        tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchBar.endEditing(true)
            searchBar.showsCancelButton = false
        }
        filteredBusinesses = searchText.isEmpty ? businesses : businesses.filter({(dataString: Business) -> Bool in
            return dataString.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        tableView.reloadData()
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let categories = filters["categories"] as? [String]
        let deals = filters["deals"] as? Bool
        let radius = filters["radius"] as? Int
        var sort : YelpSortMode?
        let sortState = filters["sort"] as! Int
        switch(sortState){
            case 1:
                sort = YelpSortMode.Distance
            case 2:
                sort = YelpSortMode.HighestRated
            default: break
        }
        
        Business.searchWithTerm("Restaurants", sort: sort, categories: categories, deals: deals, radius: radius, offset: nil) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = businesses
            self.tableView.reloadData()
            self.tableLoaded = true
        }
    }

       // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
}
}