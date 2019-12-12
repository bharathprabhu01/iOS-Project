//
//  ResMainViewController.swift
//  SweetDeal
//
//  Created by Sandy Pan on 12/6/19.
//

import UIKit
import Firebase

class ResMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var ref: DatabaseReference!
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
  

  @IBAction func deleteAction(_ sender: UIBarButtonItem) {
    self.myDealList.isEditing = !self.myDealList.isEditing
    sender.title = (self.myDealList.isEditing) ? "Done" : "Delete a Deal"
  }
  
  @IBOutlet weak var myResName: UILabel!
  @IBOutlet weak var myResPic: UIImageView!
  @IBOutlet weak var myDealList: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ref = Database.database().reference()
    myDealList.delegate = self
    myDealList.dataSource = self
    getDeals()
    print(self.myDeals)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    myResName.text = self.myRes.name
    if self.myRes.imageURL==""{
      myResPic.image = nil
    } else {
      let imageUrl = URL(string: self.myRes.imageURL)!
      let imageData = try! Data(contentsOf: imageUrl)
      let image = UIImage(data: imageData)
      myResPic.image = image
    }
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
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      let dealParts = self.myDeals[indexPath.row].id.split(separator: ";")
      print(dealParts[1])
      self.myDeals.remove(at: indexPath.row)
      self.myDealList.deleteRows(at: [indexPath], with: .automatic)
      ref.child("Deals").child(String(dealParts[1])).removeValue()
      myDealList.reloadData()
    }
  }
  
  //get updated deals after hitting save from addDealsViewController
  @IBAction func unwindToDealList(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.source as? AddDealViewController, let deal = sourceViewController.deal {
      let newIndexPath = IndexPath(row: myDeals.count, section: 0)
      myDeals.append(deal)
      myDealList.insertRows(at: [newIndexPath], with: .automatic)
      myDealList.reloadData()
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
        if restaurant_id == self.myRes.id {
          name = deal.name
          description = deal.description
          valid_until = deal.valid_until
          id = deal.id
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
