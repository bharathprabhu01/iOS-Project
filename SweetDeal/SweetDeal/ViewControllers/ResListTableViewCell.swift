//
//  ResListTableViewCell.swift
//  SweetDeal
//
//  Created by Sandy Pan on 12/5/19.
//

import UIKit

class ResListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var resImage: UIImageView!
  @IBOutlet weak var resName: UILabel!
  @IBOutlet weak var resCategories: UILabel!
  @IBOutlet weak var resAddress: UILabel!
  @IBOutlet weak var distLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
