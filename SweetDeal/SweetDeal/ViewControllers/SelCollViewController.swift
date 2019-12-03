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
    var lat: Float = 0.0
    var long: Float = 0.0
    var zip: Int = 0
    
    let url = "https://sweetdeal-94e7c.firebaseio.com/Colleges.json"
    
    let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
      guard let data = data else {
        print("Error: No data to decode")
        return
      }
      
      guard let result = try? JSONDecoder().decode([CollegeRes].self, from: data) else {
        print("Error: Couldn't decode data into a result")
        return
      }
      
      for college in result {
        name = college.name
        address = college.address
        city = college.city
        state = college.state
        lat = college.latitude
        long = college.longitude
        zip = college.zip
        var col = College(name: name, address: address, city: city, state: state, lat: lat, long: long, zip: zip)
        self.colleges.append(col)
        DispatchQueue.main.async {
          self.collGrid.reloadData()
        }
      }
    }
    task.resume()
  }
}
