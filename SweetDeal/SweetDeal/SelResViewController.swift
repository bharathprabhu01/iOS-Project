import UIKit
import Firebase

class SelResViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  var ref: DatabaseReference!
  var currUserID: String = ""
  var currUserFN: String = ""
  var currUserLN: String = ""
  var currUserEmail: String = ""
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
    
    let width = (view.frame.size.width-100)/3
    let layout = resGrid.collectionViewLayout as! UICollectionViewFlowLayout
    layout.itemSize = CGSize(width:width, height:width)
  }
      
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.restaurants.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantCell", for: indexPath) as! ResGridCollectionViewCell
    let imageUrl = URL(string: self.restaurants[indexPath.row].imageURL)!
    let imageData = try! Data(contentsOf: imageUrl)
    let image = UIImage(data: imageData)
    cell.resPic.setBackgroundImage(image, for: .normal)
    cell.resNameLabel.text = self.restaurants[indexPath.row].name
    return cell
  }
  
//  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    
//  }
    
  func retrieveRestaurants() {
    var name: String = ""
    var imageURL: String = ""
    var phone: String = ""
    
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
            var res = Restaurant(name: name, phone: phone, imageURL: imageURL)
            self.restaurants.append(res)
            DispatchQueue.main.async {
                self.resGrid.reloadData()
            }
        }
    }
    task.resume()
  }
    
    
    
}

