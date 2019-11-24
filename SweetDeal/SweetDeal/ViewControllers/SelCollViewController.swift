import UIKit
import Firebase

class SelCollViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  var ref: DatabaseReference!
  var currUserID: String = ""
  var currUserFN: String = ""
  var currUserLN: String = ""
  var currUserEmail: String = ""
  var colleges = [College]()
  
  @IBOutlet weak var currUserLabel: UILabel!
  @IBOutlet weak var collGrid: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collGrid.delegate = self
    collGrid.dataSource = self
    ref = Database.database().reference()
    currUserLabel.text = "Welcome " + currUserFN + ","
    retrieveColleges()
    let width = (view.frame.size.width-100)/3
    let layout = collGrid.collectionViewLayout as! UICollectionViewFlowLayout
    layout.itemSize = CGSize(width:width, height:width)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.colleges.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collegeCell", for: indexPath) as! CollGridCollectionViewCell
    cell.collNameLabel.text = self.colleges[indexPath.row].name
    return cell
  }
  
  func retrieveColleges() {
    var name: String = ""
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var lat: Double = 0.0
    var long: Double = 0.0
    var zip: Int = 0
    
    //retrieving data from firebase
  ref.child("Colleges").observeSingleEvent(of: .value, with: { (snapshot) in
    if let collList = snapshot.value as? [String: AnyObject] {
      for (key,obj) in collList {
        name = key
        if let tempAddress = obj["ADDRESS"] as? String {
          address = tempAddress
        }
        if let tempCity = obj["CITY"] as? String {
          city = tempCity
        }
        if let tempState = obj["STATE"] as? String {
          state = tempState
        }
        if let tempLat = obj["Lat"] as? Double {
          lat = tempLat
        }
        if let tempLong = obj["Long"] as? Double {
          long = tempLong
        }
        if let tempZip = obj["ZIP"] as? Int {
          zip = tempZip
        }
        var college = College(name:name, address:address, city:city, state:state, lat:lat, long:long, zip:zip)
        self.colleges.append(college)
        DispatchQueue.main.async {
          self.collGrid.reloadData()
        }
      }
    }
  })
}

  

}
