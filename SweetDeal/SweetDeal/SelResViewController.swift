//
//  SelResViewController.swift
//  SweetDeal
//
//  Created by Sandy Pan on 11/21/19.
//

import UIKit

class SelResViewController: UIViewController {
  var currUserID:String = ""
  var currUserFN:String = ""
  var currUserLN:String = ""
  var currUserEmail:String = ""
  
  @IBOutlet weak var currUserLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    currUserLabel.text = currUserFN + ","
  }
  
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
