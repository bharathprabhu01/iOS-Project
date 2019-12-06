//
//  ResDealViewController.swift
//  SweetDeal
//
//  Created by Sandy Pan on 12/5/19.
//

import UIKit

class ResDealViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var currUserID: String?
  var currUserFN: String?
  var currUserLN: String?
  var currUserEmail: String?
  
  var deals = [Deal]()
  var currRes: Restaurant!

  @IBOutlet weak var restaurantImage: UIImageView!
  @IBOutlet weak var restaurantName: UILabel!
  @IBOutlet weak var restaurantCategory: UILabel!
  @IBOutlet weak var restaurantAddress: UILabel!
  @IBOutlet weak var restaurantPhone: UILabel!
  @IBOutlet weak var restaurantHours: UILabel!
  @IBOutlet weak var dealsTable: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    dealsTable.delegate = self
    dealsTable.dataSource = self
    getDeals()
    populateUI()
    
//    restaurantName.text = self.currResID
  
    print("Selected ResID", self.currRes )
  }
  
  override func viewWillAppear(_ animated: Bool) {
    restaurantName.text = self.currRes.name
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return self.deals.count
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "dealCell", for: indexPath) as! DealsTableViewCell
//    let cell.
    return cell
  }
  
  func populateUI() {
    
//    print(self.currRes)
//    restaurantName.text = self.currResID
//    //formating address
//    var display_add = self.currRes!.street_address
//    display_add = display_add! + ", "
//    display_add = display_add! + self.currRes!.city!
//    display_add = display_add! + ", "
//    display_add = display_add! + self.currRes!.state!
//    restaurantAddress.text = display_add
//    restaurantCategory.text = self.currRes!.categories
    
    
  }
  
  


  func getDeals() {
    
  }
  




}
