//
//  SelResViewController.swift
//  SweetDeal
//
//  Created by Sandy Pan on 11/21/19.
//

import UIKit
import Firebase

class SelResViewController: UIViewController{
  var ref: DatabaseReference!
  var currUserID: String = ""
  var currUserFN: String = ""
  var currUserLN: String = ""
  var currUserEmail: String = ""
  var restaurantList: Dictionary<String, AnyObject> = [:]
  
  @IBOutlet weak var currUserLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ref = Database.database().reference()
    currUserLabel.text = "Welcome " + currUserFN + ","
    ref.child("Restaurants").observeSingleEvent(of: .value, with: { (snapshot) in
      if let resList = snapshot.value as? [String: AnyObject] {
        self.restaurantList = resList
//        print(self.restaurantList)
//        self.idLabel.text = dictionary["postID"] as? String
      }
    })
    
  }
  
//  func readDeal(
//    return ref.("/users/" + self.currUserID).once("value").then(function(snapshot) {
//
//    var username = (snapshot.val() && snapshot.val().username) || "Anonymous";
//
//    });)
  
  
  
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
