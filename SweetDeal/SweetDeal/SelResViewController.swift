import UIKit
import Firebase

class SelResViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  var ref: DatabaseReference!
  var currUserID: String = ""
  var currUserFN: String = ""
  var currUserLN: String = ""
  var currUserEmail: String = ""
  var restaurants = [Restaurant](){
    didSet {
      DispatchQueue.main.async {
        self.resGrid.reloadData()
      }
    }
  }
  var fullRestaurants = [Restaurant]()
  var selectedIndexPath: IndexPath?
  var madeSelection: Bool = false
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var currUserLabel: UILabel!
  @IBOutlet weak var resGrid: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    resGrid.delegate = self
    resGrid.dataSource = self
    ref = Database.database().reference()
    currUserLabel.text = "Welcome " + currUserFN + ","
    
    retrieveRestaurants()
    
    searchBar.delegate = self as? UISearchBarDelegate
    
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
      resRef.child("name").setValue(selectedRes.name)
      resRef.child("phone").setValue(selectedRes.phone)
      resRef.child("imageURL").setValue(selectedRes.imageURL)
      resRef.child("id").setValue(selectedRes.id)
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.destination is ResMainViewController {
      let vc = segue.destination as? ResMainViewController
      
      let indexPath = resGrid.indexPathsForSelectedItems?.first?.item
      if let selectedPath = indexPath {
        vc?.myRes = restaurants[selectedPath]
      }
      vc?.currUserID = self.currUserID
      vc?.currUserFN = self.currUserFN
      vc?.currUserLN = self.currUserLN
      vc?.currUserEmail = self.currUserEmail
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
          self.fullRestaurants.append(res)
          DispatchQueue.main.async {
              self.resGrid.reloadData()
          }
        }
    }
    task.resume()
  }
}

//extensions
extension SelResViewController: UISearchBarDelegate {
  
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    searchBar.showsCancelButton = true
    return true
  }
  
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchBarText = searchBar.text else {return}
    
    if searchBarText == "" {
      self.restaurants = self.fullRestaurants
    } else {
      
      var resultListOfRestaurants = [Restaurant]()
      
      for rest in self.fullRestaurants {
        if(rest.name.contains(searchBarText)){
          resultListOfRestaurants.append(rest)
        }
      }
      
      self.restaurants = resultListOfRestaurants
      
    }
    
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
    self.searchBar.text = ""
    self.restaurants = self.fullRestaurants
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    self.restaurants = self.fullRestaurants
  }
  
}
