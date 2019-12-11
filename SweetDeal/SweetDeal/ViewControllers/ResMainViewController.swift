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
  var myDeals = [Deal]() {
    didSet {
      DispatchQueue.main.async {
        self.myDealList.reloadData()
      }
    }
  }
  var totalDealCount = 0
  

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
  
  //get updated deals after hitting save from addDealsViewController
  @IBAction func unwindToDealList(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.source as? AddDealViewController, let deal = sourceViewController.deal {
      let newIndexPath = IndexPath(row: myDeals.count, section: 0)
      myDeals.append(deal)
      myDealList.insertRows(at: [newIndexPath], with: .automatic)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.destination is AddDealViewController {
      let vc = segue.destination as? AddDealViewController
      vc?.currUserID = self.currUserID
      vc?.currUserFN = self.currUserFN
      vc?.currUserLN = self.currUserLN
      vc?.currUserEmail = self.currUserEmail
      vc?.myRes = self.myRes
      vc?.totalDealCount = self.totalDealCount
    }
  }

  //fetching deals from firebase using decodable
  func getDeals() {
    var description: String = ""
    var id: String = ""
    var name: String = ""
    var valid_until: String = ""
    var restaurant_id: String = ""
    
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
        restaurant_id = deal.restaurantsID
        self.totalDealCount += 1
        if restaurant_id == self.myRes.id {
          name = deal.name
          description = deal.description
          valid_until = deal.valid_until
          var deal = Deal(description: description, id: id, name: name, valid_until: valid_until, restaurant: restaurant_id)
         
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
