//
//  DealsTableViewCell.swift
//  SweetDeal
//
//  Created by Sandy Pan on 12/5/19.
//

import UIKit

class DealsTableViewCell: UITableViewCell {
  @IBOutlet weak var dealName: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
