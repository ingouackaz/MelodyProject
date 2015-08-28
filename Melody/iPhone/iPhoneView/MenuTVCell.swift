//
//  MenuTVCell.swift
//  Melody.Tv
//
//  Created by Roger Ingouacka on 18/11/14.
//  Copyright (c) 2014 Roger Ingouacka. All rights reserved.
//

import UIKit

class MenuTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}
