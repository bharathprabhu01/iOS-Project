//
//  StuMainViewController.swift
//  SweetDeal
//
//  Created by Sandy Pan on 12/5/19.
//

import UIKit
import Firebase

class StuMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var currUserID: String?
  var currUserFN: String?
  var currUserLN: String?
  var currUserEmail: String?
  var restaurants = [Restaurant]()
  
  @IBOutlet weak var resList: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    resList.delegate = self
    resList.dataSource = self
//    ref = Database.database().reference()
    getRestaurants()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.restaurants.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! ResListTableViewCell
    //Formatting display address
    var display_add = self.restaurants[indexPath.row].street_address
    display_add = display_add! + ", " as! String
    display_add = display_add! + self.restaurants[indexPath.row].city! as! String
    display_add = display_add! + ", " as! String
    display_add = display_add! + self.restaurants[indexPath.row].state! as! String
    //res name
    cell.resName.text = self.restaurants[indexPath.row].name
    //list of categories
    cell.resCategories.text = self.restaurants[indexPath.row].categories
    cell.resAddress.text = display_add
    //res image
    let imageUrl = URL(string: self.restaurants[indexPath.row].imageURL)!
    let imageData = try! Data(contentsOf: imageUrl)
    let image = UIImage(data: imageData)
    cell.resImage.image = image
    return cell
  }
  
  //Passing curr user info to next view
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.destination is StuMainViewController {
      let vc = segue.destination as? StuMainViewController
      vc?.currUserID = self.currUserID
      vc?.currUserFN = self.currUserFN
      vc?.currUserLN = self.currUserLN
      vc?.currUserEmail = currUserEmail
    }
  }
  
  
  
  func getRestaurants() {
    var name: String = ""
    var imageURL: String = ""
    var phone: String = ""
    var categories: String = ""
    var street_address: String = ""
    var city: String = ""
    var state: String = ""
    var zip: String = ""

    
    let url = "https://sweetdeal-94e7c.firebaseio.com/Restaurants.json"
    
    let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
      guard let data = data else {
        print("Error: No data to decode")
        return
      }
      
      guard let result = try? JSONDecoder().decode([Rest].self, from: data) else {
        print("Error: Couldn't decode data into a result")
        return
      }
      
      for restaurant in result {
        if let temp = restaurant.name {
          name = temp
        }
        if let temp = restaurant.image_url {
          imageURL = temp
        }
        if let temp = restaurant.phone {
          phone = temp
        }
        if let temp = restaurant.categories {
          for c in temp {
            if let title = c.title {
              categories += title
              categories += ", "
            }
          }
        }
        if let temp = restaurant.location {
          if let street = temp.address1 {
            street_address = street
          }
          if let t_city = temp.city {
            city = t_city
          }
          if let t_state = temp.state {
            state = t_state
          }
          if let t_zip = temp.zipcode {
            zip = t_zip
          }
        }
        var res = Restaurant(name: name, phone: phone, imageURL: imageURL, categories: categories, street_address: street_address, city: city, state: state, zip: zip)
        self.restaurants.append(res)
        DispatchQueue.main.async {
          self.resList.reloadData()
        }
      }
    }
    task.resume()
  }
  

}
