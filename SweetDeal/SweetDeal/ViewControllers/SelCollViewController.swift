import UIKit
import Firebase

class SelCollViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var ref: DatabaseReference!
  var currUserID: String = ""
  var currUserFN: String = ""
  var currUserLN: String = ""
  var currUserEmail: String = ""
  var colleges = [College]()
  var filterColleges = [College]()
  
  let searchController = UISearchController(searchResultsController: nil)
  
  @IBOutlet weak var currUserLabel: UILabel!
  @IBOutlet weak var collTable: UITableView!
  
  func filterContentForSearchText(searchText: String, scope: String = "All") {
    filterColleges = colleges.filter{
      college in return college.name.lowercased().contains(searchText.lowercased())
    }
    collTable.reloadData()
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collTable.delegate = self
    collTable.dataSource = self
    ref = Database.database().reference()
    currUserLabel.text = "Welcome " + currUserFN + ","
    retrieveColleges()
 
    //Search
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    collTable.tableHeaderView = searchController.searchBar
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //check if user searching
    if searchController.isActive && searchController.searchBar.text != "" {
      return self.filterColleges.count
    }
    return self.colleges.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "collegeCell", for: indexPath) as! CollTableViewCell
    if searchController.isActive && searchController.searchBar.text != "" {
      cell.collNameLabel.text = self.filterColleges[indexPath.row].name
    } else {
      cell.collNameLabel.text = self.colleges[indexPath.row].name
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //checking if searching
    var selectedColl: College?
    if searchController.isActive && searchController.searchBar.text != "" {
      selectedColl = self.filterColleges[indexPath.row]
    } else {
      selectedColl = self.colleges[indexPath.row]
    }
    let collegeRef = self.ref.child("Users").child(currUserID).child("college")
    let collegeName = collegeRef.child("name")
    collegeName.setValue(selectedColl!.name)
    let userType = self.ref.child("Users").child(currUserID).child("is_student")
    userType.setValue(true)
  }
  
  //Passing curr user info to next view
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.destination is StuMainViewController {
      let vc = segue.destination as? StuMainViewController
      vc?.currUserID = self.currUserID
      vc?.currUserFN = self.currUserFN
      vc?.currUserLN = self.currUserLN
      vc?.currUserEmail = self.currUserEmail
    }
  }
  
  
  //Retrieving colleges from API
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

extension SelCollViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchText: searchController.searchBar.text!)
  }
  
  
  
}
