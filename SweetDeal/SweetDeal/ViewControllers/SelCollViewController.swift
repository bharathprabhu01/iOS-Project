import UIKit
import Firebase

class SelCollViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var ref: DatabaseReference!
  var currUserID: String = ""
  var currUserFN: String = ""
  var currUserLN: String = ""
  var currUserEmail: String = ""
  var colleges = [College]()
  
  @IBOutlet weak var currUserLabel: UILabel!
  @IBOutlet weak var collTable: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collTable.delegate = self
    collTable.dataSource = self
    ref = Database.database().reference()
    currUserLabel.text = "Welcome " + currUserFN + ","
    retrieveColleges()
//    let width = (view.frame.size.width-100)/3
//    let layout = collGrid.tableViewLayout as! UITableViewFlowLayout
//    layout.itemSize = CGSize(width:width, height:width)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.colleges.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "collegeCell", for: indexPath) as! CollTableViewCell
    cell.collNameLabel.text = self.colleges[indexPath.row].name
    return cell
  }
  
//  self.ref = Database.database().reference()
//
//  let uid = Auth.auth().currentUser?.uid
//  let thisUsersGamesRef = self.ref.child("users").child(uid!).child("Games")
//
//  let gameRef0 = thisUsersGamesRef.childByAutoId().child("game_url")
//  gameRef0.setValue("http://www...")
//
//  let gameRef1 = thisUsersGamesRef.childByAutoId().child("game_url")
//  gameRef1.setValue("http://www..")
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedColl = self.colleges[indexPath.row]
    let collegeRef = self.ref.child("Users").child(currUserID).child("college")
    let collegeName = collegeRef.child("name")
    collegeName.setValue(selectedColl.name)
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
          self.collTable.reloadData()
        }
      }
    }
    task.resume()
  }
}
