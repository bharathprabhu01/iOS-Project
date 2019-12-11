//
//  AddDealViewController.swift
//  SweetDeal
//
//  Created by Sandy Pan on 12/10/19.
//

import UIKit
import os.log
import Firebase

class AddDealViewController: UIViewController {
  var ref: DatabaseReference!
  private var datePicker: UIDatePicker?
  var currUserID: String?
  var currUserFN: String?
  var currUserLN: String?
  var currUserEmail: String?
  
  var myRes: Restaurant!
  var totalDealCount: Int?
  var deal: Deal?


  @IBOutlet weak var save: UIBarButtonItem!
  @IBOutlet weak var cancel: UIBarButtonItem!
  @IBOutlet weak var couponDetail: UITextField!
  @IBOutlet weak var expirationDateField: UITextField!
  @IBOutlet weak var couponNameField: UITextField!

  @IBAction func cancel(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    //fire base ref
    ref = Database.database().reference()
    //adding rounded borders for text fields
    couponDetail.borderStyle = UITextField.BorderStyle.roundedRect
    expirationDateField.borderStyle = UITextField.BorderStyle.roundedRect
    //date picker
    datePicker = UIDatePicker()
    datePicker?.datePickerMode = .date
    datePicker?.addTarget(self, action: #selector(AddDealViewController.dateChange(datePicker:)), for: .valueChanged)
    //Dismiss date chooser if user wants to w/o making selection
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddDealViewController.viewTapped(gestureRecognizer:)))
    view.addGestureRecognizer(tapGesture)
    expirationDateField.inputView = datePicker
  }
  
  //handler method for display date picked through date picker
  @objc func dateChange(datePicker: UIDatePicker) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    expirationDateField.text = dateFormatter.string(from: datePicker.date)
    view.endEditing(true)
  }
  
  //handler method for dismissing date chooser
  @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
    #selector(AddDealViewController.viewTapped(gestureRecognizer:))
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    //save button
    guard let button = sender as? UIBarButtonItem, button === save else {
      os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
      return
    }
    
    //creating deal object
    let desc = couponDetail.text!
    let name = couponNameField.text!
    let validUntil = expirationDateField.text!
    //formating deal id
    var newTotal: Int = 0
    if let total = self.totalDealCount {
      newTotal = total
    }
    //creating deal
    var dealID = "Deal" + String(newTotal)
    self.deal = Deal(description: desc, id: dealID, name: name, valid_until: validUntil, restaurant: myRes.id)
    
    //inserting to firebase
    let dict = ["description" : desc, "id" : dealID, "name" : name, "valid_until": validUntil, "restID": myRes.id]
    self.ref.child("Deals").child(String(newTotal)).setValue(dict)
  }

}
