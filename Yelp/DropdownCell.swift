//
//  DropdownCell.swift
//  Yelp
//
//  Created by Anvisha Pai on 9/27/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class DropdownCell: UITableViewCell {

    @IBOutlet weak var dropdownLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.Default
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
