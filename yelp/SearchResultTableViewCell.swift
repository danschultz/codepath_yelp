//
//  SearchResultCellTableViewCell.swift
//  yelp
//
//  Created by Dan Schultz on 9/17/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    
    var _business: Business?
    var business: Business? {
        get {
            return _business
        }
        
        set {
            _business = newValue
            updateFields()
        }
    }
    
    var _resultNumber: Int?
    var resultNumber: Int? {
        get {
            return _resultNumber
        }
        set {
            _resultNumber = newValue
            updateFields()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateFields() {
        if (business != nil && resultNumber != nil) {
            titleLabel.text = "\(resultNumber!). \(business!.name)"
            reviewCountLabel.text = "\(business!.reviewCount) reviews"
            streetAddressLabel.text = business!.address
            tagsLabel.text = ", ".join(business!.categories.map({ "\($0)" }))
            distanceLabel.text = business!.distance != nil ? NSString(format: "%.1f mi", business!.distance!) : ""
            thumbnailImage.setImageWithURL(business!.imageUrl)
            ratingImage.setImageWithURL(business!.ratingImageUrl)
        }
    }

}
