//
//  MyDealTableViewCell.swift
//  SweetDeal
//
//  Created by Sandy Pan on 12/6/19.
//

import UIKit

class MyDealTableViewCell: UITableViewCell {

  @IBOutlet weak var dealName: UILabel!
  @IBOutlet weak var dealDescription: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
