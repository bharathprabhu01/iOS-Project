//
//  StuMainViewController.swift
//  SweetDeal
//
//  Created by Sandy Pan on 12/5/19.
//

import UIKit
import Firebase
import CoreLocation

class StuMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
  var currUserID: String?
  var currUserFN: String?
  var currUserLN: String?
  var currUserEmail: String?
  var restaurants = [Restaurant](){
    didSet {
      DispatchQueue.main.async {
        self.resList.reloadData()
      }
    }
  }
  
  var allRestaurants = [Restaurant]()
  //The restaurant that the user clicks on in the table to see deals for
  var restName:String?
  let locationManager = CLLocationManager()
  
  @IBOutlet weak var search: UISearchBar!
  @IBOutlet weak var resList: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    resList.delegate = self
    resList.dataSource = self
    //search
    search.delegate = self as? UISearchBarDelegate
    getRestaurants()
    //location tracker
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.startUpdatingLocation()
    }
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     tableView.deselectRow(at: indexPath, animated: true)
  }
  
  @IBAction func unwindToStuMain(sender: UIStoryboardSegue) {
  }
  
  //Passing curr user info to next view
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.destination is ResDealViewController {      
      let vc = segue.destination as? ResDealViewController
      if let resIndex = resList.indexPathForSelectedRow?.row {
        vc?.currRes = restaurants[resIndex]
      }
      vc?.currUserID = self.currUserID
      vc?.currUserFN = self.currUserFN
      vc?.currUserLN = self.currUserLN
      vc?.currUserEmail = self.currUserEmail
    }
  }
  
  //Tracking user longitude/latitutde
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      // change this as necessary
      print(location.coordinate)
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
    var longitude: Float = 0.0
    var latitude: Float = 0.0
    var price: String = ""
    var review_count: Int = 0
    var rating: Float = 0.0
    var hours: String = ""
    var id: String = ""
    var countObj: Int = 0
    var countCate: Int = 0
    var dealIDs = [String]()

    
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
        //only display restaurants with deals
        if restaurant.dealIDs != nil {
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
              //            countCate += 1
              if let title = c.title {
                categories += title
                //              if title != (temp[temp.count-1].title) {
                categories += ", "
                //              }
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
          if let coord = restaurant.coordinates {
            let latitude = coord.latitude
            let longitude = coord.longitude
          }
          if let temp = restaurant.price {
            price = temp
          }
          if let t_rc = restaurant.review_count {
            review_count = t_rc
          }
          if let t_rating = restaurant.rating {
            rating = t_rating
          }
          if let t_hours = restaurant.hours {
            var hoursConvert = [0: "Sunday", 1: "Monday", 2: "Tuesday", 3: "Wednesday", 4: "Thursday", 5: "Friday", 6: "Saturday"]
            for h in t_hours {
              countObj += 1
              if let day = h.day {
                //day of week
                if let dayOfWeek = hoursConvert[day] {
                  hours = hours + dayOfWeek
                  hours = hours + ": "
                }
              }
              //start time
              if let startT = h.start {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HHmm"
                if let oldStart = dateFormatter.date(from: startT) {
                  dateFormatter.dateFormat = "h:mm a"
                  let newStart = dateFormatter.string(from: oldStart)
                  hours = hours + newStart
                  hours = hours + " - "
                }
              }
              //end time
              if let endT = h.end {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HHmm"
                if let oldEnd = dateFormatter.date(from: endT) {
                  dateFormatter.dateFormat = "h:mm a"
                  let newEnd = dateFormatter.string(from: oldEnd)
                  hours = hours + newEnd
                  //                if countObj != t_hours.count {
                  hours = hours + "\n"
                  //                }
                }
              }
            }
          }
          if let t_id = restaurant.id {
            id = t_id
          }
          if let t_deals = restaurant.dealIDs {
            dealIDs = t_deals
          }
          var res = Restaurant(name: name, phone: phone, imageURL: imageURL, categories: categories, street_address: street_address, city: city, state: state, zip: zip, longitude: longitude, latitude: latitude, price: price, review_count: review_count, rating: rating, hours: hours, id: id, dealIDs: dealIDs)
          self.restaurants.append(res)
          self.allRestaurants.append(res)
          DispatchQueue.main.async {
            self.resList.reloadData()
          }
        }
         continue
      }
    }
    task.resume()
  }
  

}

extension StuMainViewController: UISearchBarDelegate {
  
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    searchBar.showsCancelButton = true
    return true
  }
  
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchBarText = searchBar.text else {return}
    
    if searchBarText == "" {
      self.restaurants = self.allRestaurants
    } else {
      
      var results = [Restaurant]()
      
      for rest in self.restaurants {
     if((rest.name.lowercased().contains(searchBarText.lowercased())) || (rest.categories!.lowercased().contains(searchBarText.lowercased()))){
          results.append(rest)
        }
      }
      
      self.restaurants = results
      
    }
    
    
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    self.restaurants = self.allRestaurants
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
    self.search.text = ""
    self.restaurants = self.allRestaurants
  }
  
}
