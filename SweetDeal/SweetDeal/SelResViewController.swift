import UIKit
import Firebase

class SelResViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  var ref: DatabaseReference!
  var currUserID: String = ""
  var currUserFN: String = ""
  var currUserLN: String = ""
  var currUserEmail: String = ""
  var selectedIndexPath: IndexPath?
  var madeSelection: Bool = false
  
  var restaurants = [Restaurant](){
    didSet {
      DispatchQueue.main.async {
        self.resGrid.reloadData()
      }
    }
  }
  
  var allRestaurants = [Restaurant]()
  
  
  
  @IBOutlet weak var search: UISearchBar!
  
  @IBOutlet weak var currUserLabel: UILabel!
  @IBOutlet weak var resGrid: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    resGrid.delegate = self
    resGrid.dataSource = self
    
    search.delegate = self as? UISearchBarDelegate
    
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
    
    //if selected show gray border around it
    if self.selectedIndexPath != nil && indexPath == self.selectedIndexPath {
//      cell.isSelected = true
//      cell.isHighlighted = true
      cell.layer.borderWidth = 2.0
      cell.layer.borderColor = UIColor.red.cgColor
    }
    return cell
  }
  
 
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if (!madeSelection) {
      //adding data to firebase
      let selectedRes = self.restaurants[indexPath.row]
      let resRef = self.ref.child("Users").child(currUserID).child("restaurant")
      let resName = resRef.child("name")
      resName.setValue(selectedRes.name)
      let ownerRef = self.ref.child("Users").child(currUserID).child("is_owner")
      ownerRef.setValue(true)
      
      //when selected show red border
      let selectedCell = collectionView.cellForItem(at: indexPath)
      selectedCell!.layer.borderWidth = 2.0
      selectedCell!.layer.borderColor = UIColor.red.cgColor
      self.selectedIndexPath = indexPath
      self.madeSelection = true
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if (madeSelection) {
      let selectedRes = collectionView.cellForItem(at: indexPath)
      //removing border
      self.madeSelection = false
      self.selectedIndexPath = nil
      let selectedCell = collectionView.cellForItem(at: indexPath)
      selectedCell!.layer.borderWidth = 0
    }
  }
  
  
  
    
  func retrieveRestaurants() {
    var name: String = ""
    var imageURL: String = ""
    var phone: String = ""
    var id: String = ""
    
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
          if let temp = restaurant.id {
            id = temp
          }
        
          
          var res = Restaurant(name: name, phone: phone, imageURL: imageURL, id: id)
          
          self.restaurants.append(res)
          self.allRestaurants.append(res)
          
            DispatchQueue.main.async {
                self.resGrid.reloadData()
            }
        }
    }
    task.resume()
  }
    
    
    
}


// Extensions
extension SelResViewController: UISearchBarDelegate {
  
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
        if((rest.name.lowercased().contains(searchBarText.lowercased()))){
          print("result", rest.name)
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

