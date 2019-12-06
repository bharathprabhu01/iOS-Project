//
//  ResMainViewController.swift
//  SweetDeal
//
//  Created by Sandy Pan on 12/6/19.
//

import UIKit

class ResMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var currUserID: String?
  var currUserFN: String?
  var currUserLN: String?
  var currUserEmail: String?
  
  var myRes: Restaurant!
  var myDeals = [Deal]()
  

  @IBOutlet weak var myResName: UILabel!
  @IBOutlet weak var myResPic: UIImageView!
  @IBOutlet weak var myDealList: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    myDealList.delegate = self
    myDealList.dataSource = self
    getDeals()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    myResName.text = self.myRes.name
    let imageUrl = URL(string: self.myRes.imageURL)!
    let imageData = try! Data(contentsOf: imageUrl)
    let image = UIImage(data: imageData)
    myResPic.image = image
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.myDeals.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "myDealCell", for: indexPath) as! MyDealTableViewCell
    cell.dealName.text = self.myDeals[indexPath.row].name
    cell.dealDescription.text = self.myDeals[indexPath.row].description
    return cell
  }
  
  
  func getDeals() {
    var description: String = ""
    var id: String = ""
    var name: String = ""
    var valid_until: String = ""
    var restaurants = [String]()
    
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
        print("Got hereee")
        restaurants = deal.restaurantsID
        if restaurants.contains(where: {$0 == self.myRes.id}) {
          name = deal.name
          description = deal.description
          valid_until = deal.valid_until
          var deal = Deal(description: description, id: id, name: name, valid_until: valid_until, restaurants: restaurants)
          self.myDeals.append(deal)
          DispatchQueue.main.async {
            self.myDealList.reloadData()
          }
        }
      }
    }
    task.resume()
  }

}
