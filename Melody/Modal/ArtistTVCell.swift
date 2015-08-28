//
//  ArtistTVCell.swift
//  Melody.Tv
//
//  Created by Roger Ingouacka on 17/11/14.
//  Copyright (c) 2014 Roger Ingouacka. All rights reserved.
//

import UIKit

class ArtistTVCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
