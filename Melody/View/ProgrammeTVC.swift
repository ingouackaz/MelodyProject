//
//  ProgrammeTVC.swift
//  Melody
//
//  Created by Roger Ingouacka on 04/12/14.
//
//

import UIKit

class ProgrammeTVC: UITableViewCell, UITableViewDelegate , UITableViewDataSource {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { // insert code}
        let cell =  tableView.dequeueReusableCellWithIdentifier("programmeCell") as UITableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // insert code
        return 10
    }
}
