//
//  ViewController.swift
//  yelp
//
//  Created by Dan Schultz on 9/17/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, FilterViewControllerDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var resultsTableView: UITableView!
    
    let yelpClient = YelpClient(
        consumerKey: "LA9w9SXIc7uT78aEw7cfcA", consumerSecret: "--5-OyV9N8vfydzkcTmZxs3cPG0",
        accessToken: "MIk9Hb9bGO1QDCKJJ2UK4rvwfRTr0ScO", accessSecret: "y6fN1Tqp4WgocuuXFyNIeWgEPrs")
    
    var results: [Business] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.dataSource = self
        resultsTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func handleDoneEnteringSearchTerm(sender: AnyObject) {
        search(["term": searchTextField.text, "location": "Sunnyvale"])
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell") as SearchResultTableViewCell
        cell.resultNumber = indexPath.row + 1
        cell.business = results[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SearchToFilter") {
            var filtersNavigationController = segue.destinationViewController as UINavigationController
            var filtersViewController = filtersNavigationController.viewControllers[0] as FilterViewController
            filtersViewController.delegate = self
        }
    }
    
    func didApplyFilter(categories: [FilterOption<NSString>], sort: FilterOption<Int>?, distance: FilterOption<Int>?, deals: Bool) {
        var params = [
            "term": searchTextField.text,
            "location": "Sunnyvale",
            "deals_filter": deals ? "true" : "false"
        ]
        
        if (categories.count > 0) {
            params["category_filter"] = ",".join(categories.map({ "\($0.value)" }))
        }

        if (sort != nil) {
            params["sort"] = "\(sort!.value)"
        }

        if (distance != nil) {
            params["distance"] = "\(distance!.value)"
        }
        
        search(params)
    }
    
    func didCancelFilter() {
        
    }
    
    func search(params: [NSString: AnyObject]) {
        var loadingView = MBProgressHUD.showHUDAddedTo(view, animated: true)
        loadingView.labelText = "Loading"
        
        yelpClient.searchWithParams(params) { (data, error) in
            self.handleSearchResponse(data["businesses"] as [[NSString: AnyObject]])
            self.resultsTableView.reloadData()
            loadingView.hide(true)
        }
    }
    
    func handleSearchResponse(businessListData: [[NSString: AnyObject]]) {
        results.removeAll()
        
        for businessData in businessListData {
            results.append(Business(values: businessData))
        }
    }

}

