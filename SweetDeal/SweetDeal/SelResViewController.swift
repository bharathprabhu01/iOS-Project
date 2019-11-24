import UIKit
import Firebase

class SelResViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  var ref: DatabaseReference!
  var currUserID: String = ""
  var currUserFN: String = ""
  var currUserLN: String = ""
  var currUserEmail: String = ""
  var cellColor = true
  var restaurantList: Dictionary<String, AnyObject> = [:]
  var restaurants = [Restaurant]()
  
  @IBOutlet weak var currUserLabel: UILabel!
  @IBOutlet weak var resGrid: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    resGrid.delegate = self
    resGrid.dataSource = self
    ref = Database.database().reference()
    currUserLabel.text = "Welcome " + currUserFN + ","
    retrieveRestaurants()
  }
      
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print(self.restaurants.count)
    return self.restaurants.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantCell", for: indexPath) as! ResGridCollectionViewCell
    
//    print(self.restaurantList[indexPath.row])
//    var restaurant = ""
//    restaurant = self.restaurantList[indexPath.row]
    print(self.restaurants[indexPath.row].name)
//    cell.resPic.image = self.restaurants[indexPath.row].imageURL
    cell.resNameLabel.text = self.restaurants[indexPath.row].name
    return cell
  }
  
  func retrieveRestaurants() {
    var name: String = ""
    var imageURL: String = ""
    var phone: String = ""
    ref.child("Restaurants").observeSingleEvent(of: .value, with: { (snapshot) in
      if let resList = snapshot.value as? [String: AnyObject] {
        for obj in resList.values {
          if let tempName = obj["name"] {
            if let resName = tempName as? String {
              name = resName
            }
          }
          if let tempPhone = obj["phone"] {
            if let resPhone = tempPhone as? String {
              phone = resPhone
            }
          }
        if let tempImageURL = obj["imageURL"] {
          if let resImageURL = tempImageURL as? String {
            imageURL = resImageURL
          }
        }
        var res = Restaurant(name: name, phone: phone, imageURL: imageURL)
        self.restaurants.append(res)
        DispatchQueue.main.async {
          self.resGrid.reloadData()
        }
      }
      }
    })
  }
}

