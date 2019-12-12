//
//  StuMainViewController.swift
//  SweetDeal
//
//  Created by Sandy Pan on 12/5/19.
//

import UIKit
import Firebase
import CoreLocation
import UserNotifications

class StuMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
  var currUserID: String?
  var currUserFN: String?
  var currUserLN: String?
  var currUserEmail: String?
  var restaurants = [Restaurant]()
  var deal_ids = [String]()
  var filteredRestaurants = [Restaurant]()
  let locationManager = CLLocationManager()
  //The restaurant that the user clicks on in the table to see deals for
  var restName:String?
  let searchController = UISearchController(searchResultsController: nil)
  
  
  @IBOutlet weak var resList: UITableView!
  
  func filterContentForSearchText(searchText: String, scope: String = "All") {
    filteredRestaurants = restaurants.filter{
      restaurant in return restaurant.name.lowercased().contains(searchText.lowercased())
    }
    resList.reloadData()
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    resList.delegate = self
    resList.dataSource = self
    //search
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    searchController.searchBar.placeholder = "Search by restaurant name or category"
    resList.tableHeaderView = searchController.searchBar
    getRestaurants()
    
    
    //pushNotifications
    requestPermissionNotifications()
    locationManager.requestAlwaysAuthorization()
    locationManager.pausesLocationUpdatesAutomatically = false
    locationManager.allowsBackgroundLocationUpdates = true
    
    
    if CLLocationManager.locationServicesEnabled() {
      self.locationManager.delegate = self
      self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
      self.locationManager.startUpdatingLocation()
      self.locationManager.distanceFilter = 20
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchController.isActive && searchController.searchBar.text != "" {
      return self.filteredRestaurants.count
    }
    return self.restaurants.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    self.restaurants = self.restaurants.sorted(by: {$0.distFrom! < $1.distFrom!})
    let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! ResListTableViewCell
    if searchController.isActive && searchController.searchBar.text != "" {
      //Formatting display address
      var display_add = self.filteredRestaurants[indexPath.row].street_address
      display_add = display_add! + ", " as! String
      display_add = display_add! + self.filteredRestaurants[indexPath.row].city! as! String
      display_add = display_add! + ", " as! String
      display_add = display_add! + self.filteredRestaurants[indexPath.row].state! as! String
      //res name
      cell.resName.text = self.filteredRestaurants[indexPath.row].name
      //list of categories
      cell.resCategories.text = self.filteredRestaurants[indexPath.row].categories
      cell.resAddress.text = display_add
      //res image
      let imageUrl = URL(string: self.filteredRestaurants[indexPath.row].imageURL)!
      let imageData = try! Data(contentsOf: imageUrl)
      let image = UIImage(data: imageData)
      cell.resImage.image = image
      
      
      //Distance calculations
      let distMiles = self.filteredRestaurants[indexPath.row].distFrom
      let n = NumberFormatter()
      n.maximumFractionDigits = 2
      let m = MeasurementFormatter()
      m.numberFormatter = n
      let distMilesString = m.string(from: distMiles!)
      cell.distLabel.text = String(distMilesString)
      
    } else {
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
    
      let distMiles = self.restaurants[indexPath.row].distFrom
      let n = NumberFormatter()
      n.maximumFractionDigits = 2
      let m = MeasurementFormatter()
      m.numberFormatter = n
      let distMilesString = m.string(from: distMiles!)
      cell.distLabel.text = String(distMilesString)
    }
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
      if searchController.isActive && searchController.searchBar.text != "" {
          if let resIndex = resList.indexPathForSelectedRow?.row {
            vc?.currRes = filteredRestaurants[resIndex]
          }
       } else {
        if let resIndex = resList.indexPathForSelectedRow?.row {
          vc?.currRes = restaurants[resIndex]
        }
      }
      vc?.currUserID = self.currUserID
      vc?.currUserFN = self.currUserFN
      vc?.currUserLN = self.currUserLN
      vc?.currUserEmail = self.currUserEmail
    }
  }
  
  func getDeals() {
//    var description: String = ""
//    var id: String = ""
//    var name: String = ""
//    var valid_until: String = ""
//    var restaurant: String = ""
    
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
        self.deal_ids.append(deal.restaurantsID)
      }
    }
    task.resume()
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
    
    getDeals()
    
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
        if self.deal_ids.contains(restaurant.id as! String) {
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
            // each item in temp is a title
            for (idx, c) in temp.enumerated() {
              if let title = c.title {
                categories += title
                if idx != temp.endIndex - 1 {
                    categories += ", "
                }
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
            if let temp = coord.latitude {
              latitude = temp
            }
            if let temp = coord.longitude {
              longitude = temp
            }
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
                  hours = hours + "\n"
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
          
          let resLong = Double(longitude)
          let resLat = Double(latitude)
          let currLong = Double((self.locationManager.location?.coordinate.longitude)!)
          let currLat = Double((self.locationManager.location?.coordinate.latitude)!)
          let coordinate₀ = CLLocation(latitude: currLat, longitude: currLong)
          let coordinate₁ = CLLocation(latitude: resLat, longitude: resLong)
          let distance = Measurement(value: coordinate₀.distance(from: coordinate₁), unit: UnitLength.meters)
          let distMiles = distance.converted(to: UnitLength.miles)
          
          var res = Restaurant(name: name, phone: phone, imageURL: imageURL, categories: categories, street_address: street_address, city: city, state: state, zip: zip, longitude: longitude, latitude: latitude, price: price, review_count: review_count, rating: rating, hours: hours, id: id, dealIDs: dealIDs, distFrom: distMiles)
          self.restaurants.append(res)
          self.createGeoFence(restaurant: res)
          categories = ""
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

extension StuMainViewController: UISearchResultsUpdating {

  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchText: searchController.searchBar.text!)
  }
  
}
