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
  @IBOutlet weak var back: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dealsTable.delegate = self
    dealsTable.dataSource = self
    getDeals()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    restaurantName.text = self.currRes.name
    restaurantCategory.text = self.currRes.categories
    //formating address
    var display_add = self.currRes!.street_address
    display_add = display_add! + ", "
    display_add = display_add! + self.currRes!.city!
    display_add = display_add! + ", "
    display_add = display_add! + self.currRes!.state!
    restaurantAddress.text = display_add
    restaurantPhone.text = self.currRes.phone
    print(self.currRes.latitude)
    print(self.currRes.longitude)

    let imageUrl = URL(string: self.currRes.imageURL)!
    let imageData = try! Data(contentsOf: imageUrl)
    let image = UIImage(data: imageData)
    restaurantImage.image = image
    restaurantHours.text = self.currRes.hours
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.deals.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "dealCell", for: indexPath) as! DealsTableViewCell
    cell.dealName.text = self.deals[indexPath.row].name
    cell.dealDescription.text = self.deals[indexPath.row].description
    if (self.deals[indexPath.row].valid_until == "nil") {
      cell.dealValidUntil.text = "Never Expires"
    }
    else{
      cell.dealValidUntil.text = "Valid Until " + self.deals[indexPath.row].valid_until
    }
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    //save button
    guard let button = sender as? UIBarButtonItem, button === back else {
      return
    }
  }
  
  func getDeals() {
    var description: String = ""
    var id: String = ""
    var name: String = ""
    var valid_until: String = ""
    var restaurant: String = ""
    
    let url = "https://sweetdeal-94e7c.firebaseio.com/Deals.json"
    
    let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
      guard let data = data else {
        print("Error: No data to decode")
        return
      }
      
      guard let result = try? JSONDecoder().decode([DealRes].self, from: data) else {
        print("Error: Couldn't decode data into a result")
        return
      }
      
      for deal in result {
        restaurant = deal.restaurantsID
        if restaurant == self.currRes.id {
          name = deal.name
          description = deal.description
          valid_until = deal.valid_until
          var deal = Deal(description: description, id: id, name: name, valid_until: valid_until, restaurant: restaurant)
          self.deals.append(deal)
          DispatchQueue.main.async {
            self.dealsTable.reloadData()
          }
        }
      }
    }
    task.resume()
  }
  
}
  





