//
//  CollTableViewCell.swift
//  SweetDeal
//
//  Created by Sandy Pan on 12/4/19.
//

import UIKit

class CollTableViewCell: UITableViewCell {
  @IBOutlet weak var collNameLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
