//
//  StuResViewController.swift
//  SweetDeal
//
//  Created by Sandy Pan on 11/17/19.
//

import UIKit

class StuResViewController: UIViewController {
  var currUserID: String?
  var currUserFN: String?
  var currUserLN: String?
  var currUserEmail: String?

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.destination is SelResViewController {
      let vc = segue.destination as? SelResViewController
      vc?.currUserID = self.currUserID!
      vc?.currUserFN = self.currUserFN!
      vc?.currUserLN = self.currUserLN!
      vc?.currUserEmail = currUserEmail!
    }
    if segue.destination is SelCollViewController {
      let vc = segue.destination as? SelCollViewController
      vc?.currUserID = self.currUserID!
      vc?.currUserFN = self.currUserFN!
      vc?.currUserLN = self.currUserLN!
      vc?.currUserEmail = currUserEmail!
    }
  }
}

