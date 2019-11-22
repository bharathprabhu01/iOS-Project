//
//  StuResViewController.swift
//  SweetDeal
//
//  Created by Sandy Pan on 11/17/19.
//

import UIKit
import Firebase

class StuResViewController: UIViewController {
//  let delegate = UIApplication.shared.delegate as! AppDelegate
//  let delegate = UIApplication.shared.delegate as! AppDelegate
//  let delegate = GIDSignIn.sharedInstance().delegate as! AppDelegate
  var ref: DatabaseReference!
  var currUserID: String?
  var currUserFN: String?
  var currUserLN: String?
  var currUserEmail: String?

  override func viewDidLoad() {
    super.viewDidLoad()
    ref = Database.database().reference()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.destination is SelResViewController {
      let vc = segue.destination as? SelResViewController
      vc?.currUserID = self.currUserID!
      vc?.currUserFN = self.currUserFN!
      vc?.currUserLN = self.currUserLN!
      vc?.currUserEmail = self.currUserEmail!
    }
  }

//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
}
