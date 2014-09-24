//
//  FilterViewController.swift
//  yelp
//
//  Created by Dan Schultz on 9/18/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var filtersTableView: UITableView!
    
    var delegate: FilterViewControllerDelegate?;
    
    var sections: [FilterSections] = [
        FilterSections.Categories,
        FilterSections.Distance,
        FilterSections.Sorting,
        FilterSections.Other
    ]
    
    var selectedCategoryOptions: [FilterOption<NSString>] = []
    var isCategorySectionExpanded = false
    var categoryOptions: [FilterOption<NSString>] = [
        FilterOption(name: "Active Life", value: "active"),
        FilterOption(name: "Arts & Entertainment", value: "arts"),
        FilterOption(name: "Automotive", value: "auto"),
        FilterOption(name: "Beauty & Spas", value: "beautysvg"),
        FilterOption(name: "Bicycles", value: "bicycles"),
        FilterOption(name: "Education", value: "education"),
        FilterOption(name: "Food", value: "food"),
        FilterOption(name: "Health & Medical", value: "health"),
        FilterOption(name: "Home Services", value: "homeservices"),
        FilterOption(name: "Hotels & Travel", value: "hotelstravel"),
        FilterOption(name: "Nightlife", value: "nightlife"),
        FilterOption(name: "Pets", value: "pets"),
        FilterOption(name: "Restaurants", value: "restaurants"),
        FilterOption(name: "Shopping", value: "shopping")
    ]
    
    var selectedSortOption: FilterOption<Int> = FilterOption(name: "Best Matched", value: 0)
    var isSortSectionExpanded = false
    var sortOptions: [FilterOption<Int>] = [
        FilterOption(name: "Best Matched", value: 0),
        FilterOption(name: "Distance", value: 1),
        FilterOption(name: "Highest Rated", value: 2)
    ]
    
    var selectedDistance: FilterOption<Int>?
    var isDistanceSectionExpanded = false
    var distanceOptions: [FilterOption<Int>] = [
        FilterOption(name: "1 mile", value: 1609),
        FilterOption(name: "5 miles", value: 8046),
        FilterOption(name: "10 miles", value: 16093),
        FilterOption(name: "25 miles", value: 40233),
        FilterOption(name: "50 miles", value: 80467)
    ]
    
    var isDealsEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filtersTableView.dataSource = self
        filtersTableView.delegate = self
    }
    
    @IBAction func handleCancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func handleSearch(sender: UIBarButtonItem) {
        delegate?.didApplyFilter(selectedCategoryOptions, sort: selectedSortOption, distance: selectedDistance, deals: isDealsEnabled)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (sections[section]) {
            case FilterSections.Categories:
                return numberOfRowsInCategoriesSection()
            case FilterSections.Distance:
                return numberOfRowsInDistanceSection()
            case FilterSections.Sorting:
                return numberOfRowsInSortingSection()
            case FilterSections.Other:
                return 1
            default:
                return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].toRaw()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (sections[indexPath.section]) {
            case FilterSections.Categories:
                return categoriesCellForRow(indexPath.row, inTableView: tableView)
            case FilterSections.Distance:
                return distanceCellForRow(indexPath.row, inTableView: tableView)
            case FilterSections.Sorting:
                return sortingCellForRow(indexPath.row, inTableView: tableView)
            case FilterSections.Other:
                return otherCellForRow(indexPath.row, inTableView: tableView)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var section = sections[indexPath.section]
        if (section == FilterSections.Categories) {
            categoriesRowSelected(indexPath, inTableView: tableView)
        } else if (section == FilterSections.Distance) {
            distanceRowSelected(indexPath, inTableView: tableView)
        } else if (section == FilterSections.Sorting) {
            sortingRowSelected(indexPath, inTableView: tableView)
        }
    }
    
    private func numberOfRowsInCategoriesSection() -> Int {
        if (isCategorySectionExpanded) {
            return categoryOptions.count
        } else {
            return 5
        }
    }
    
    private func categoriesCellForRow(row: Int, inTableView tableView: UITableView) -> UITableViewCell {
        if (isCategorySectionExpanded || row < 4) {
            var cell = tableView.dequeueReusableCellWithIdentifier("FilterGenericCell") as UITableViewCell
            cell.textLabel?.text = categoryOptions[row].name
            
            if let selected = find(selectedCategoryOptions, categoryOptions[row]) {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            
            return cell
        } else {
            return tableView.dequeueReusableCellWithIdentifier("ShowAllCell") as UITableViewCell
        }
    }
    
    private func categoriesRowSelected(indexPath: NSIndexPath, inTableView tableView: UITableView) {
        var rowAnimation = UITableViewRowAnimation.None
        
        if (!isCategorySectionExpanded && indexPath.row == 4) {
            isCategorySectionExpanded = true
            rowAnimation = UITableViewRowAnimation.Fade
        } else {
            var index = find(selectedCategoryOptions, categoryOptions[indexPath.row])
            if (index == nil) {
                selectedCategoryOptions.append(categoryOptions[indexPath.row])
            } else {
                selectedCategoryOptions.removeAtIndex(index!)
            }
        }
        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: rowAnimation)
    }
    
    private func numberOfRowsInDistanceSection() -> Int {
        if (isDistanceSectionExpanded) {
            return distanceOptions.count
        } else {
            return 1
        }
    }
    
    private func distanceCellForRow(row: Int, inTableView tableView: UITableView) -> UITableViewCell {
        if (isDistanceSectionExpanded) {
            var cell = tableView.dequeueReusableCellWithIdentifier("FilterGenericCell") as UITableViewCell
            cell.textLabel?.text = distanceOptions[row].name
            
            if (distanceOptions[row] == selectedDistance) {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("ExpandCell") as UITableViewCell
            if let selection = selectedDistance {
                cell.textLabel?.text = selection.name
            } else {
                cell.textLabel?.text = "Distance"
            }
            return cell
        }
    }
    
    private func distanceRowSelected(indexPath: NSIndexPath, inTableView tableView: UITableView) {
        var rowAnimation = UITableViewRowAnimation.None
        
        if (!isDistanceSectionExpanded) {
            isDistanceSectionExpanded = true
            rowAnimation = UITableViewRowAnimation.Fade
        } else if (selectedDistance != distanceOptions[indexPath.row]) {
            selectedDistance = distanceOptions[indexPath.row]
        } else {
            selectedDistance = nil
        }
        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: rowAnimation)
    }
    
    private func numberOfRowsInSortingSection() -> Int {
        if (isSortSectionExpanded) {
            return sortOptions.count
        } else {
            return 1
        }
    }
    
    private func sortingCellForRow(row: Int, inTableView tableView: UITableView) -> UITableViewCell {
        if (isSortSectionExpanded) {
            var cell = tableView.dequeueReusableCellWithIdentifier("FilterGenericCell") as UITableViewCell
            cell.textLabel?.text = sortOptions[row].name
            
            if (sortOptions[row] == selectedSortOption) {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("ExpandCell") as UITableViewCell
            cell.textLabel?.text = selectedSortOption.name
            return cell
        }
    }
    
    private func sortingRowSelected(indexPath: NSIndexPath, inTableView tableView: UITableView) {
        var rowAnimation = UITableViewRowAnimation.None
        
        if (!isSortSectionExpanded) {
            isSortSectionExpanded = true
            rowAnimation = UITableViewRowAnimation.Fade
        } else if (selectedSortOption != sortOptions[indexPath.row]) {
            selectedSortOption = sortOptions[indexPath.row]
        } else {
            selectedDistance = nil
        }
        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: rowAnimation)
    }
    
    private func otherCellForRow(row: Int, inTableView tableView: UITableView) -> UITableViewCell {
        assert(row == 0, "More than 1 row in 'Other' section is unsupported")
        
        var cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell") as ToggleTableViewCell
        cell.textLabel?.text = "Show Deals"
        cell.toggleSwitch.on = isDealsEnabled
        cell.toggleSwitch.addTarget(self, action: "handleDealChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        return cell
    }
    
    func handleDealChanged(sender: UISwitch) {
        isDealsEnabled = sender.on
    }

}

enum FilterSections: NSString {
    case Categories = "Categories"
    case Sorting = "Sorting"
    case Distance = "Distance"
    case Other = "Other"
}

struct FilterOption<T: Equatable>: Equatable {
    var name: NSString
    var value: T
    
    init(name: NSString, value: T) {
        self.name = name
        self.value = value
    }
}

func == <T: Equatable>(lhs: FilterOption<T>, rhs: FilterOption<T>) -> Bool {
    return lhs.name == rhs.name && lhs.value == rhs.value
}
