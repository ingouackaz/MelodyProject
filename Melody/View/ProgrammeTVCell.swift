//
//  ProgrammeTVCell.swift
//  Melody
//
//  Created by Roger Ingouacka on 05/12/14.
//
//

import UIKit

class ProgrammeTVCell: UITableViewCell {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var titleEmissionLabel: UILabel!
    @IBOutlet weak var genderEmissionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
