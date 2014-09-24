//
//  FilterViewDelegate.swift
//  yelp
//
//  Created by Dan Schultz on 9/20/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import Foundation

protocol FilterViewControllerDelegate : NSObjectProtocol {
    func didApplyFilter(categories: [FilterOption<NSString>], sort: FilterOption<Int>?, distance: FilterOption<Int>?, deals: Bool)
    
    func didCancelFilter()
}
