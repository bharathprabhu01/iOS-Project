import UIKit
import CoreLocation
import UserNotifications
import MapKit
import GoogleSignIn

class ViewController: UIViewController, CLLocationManagerDelegate {
    
  let locationManager = CLLocationManager()
  
    
  @IBAction func googleSignInClicked(_ sender: GIDSignInButton) {
    GIDSignIn.sharedInstance().signIn()
  }

  override func viewDidLoad() {
      super.viewDidLoad()
     //  Google Sign in
      GIDSignIn.sharedInstance()?.presentingViewController = self
      GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    
     // Request authorization to track location
     requestPermissionNotifications()
     locationManager.requestAlwaysAuthorization()
    
  }
}

