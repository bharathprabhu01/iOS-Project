import UIKit
import CoreLocation
import UserNotifications
import MapKit
import GoogleSignIn

class ViewController: UIViewController, CLLocationManagerDelegate {
  let locationManager = CLLocationManager()
  
    
  @IBAction func googleSignInClicked(_ sender: UIButton) {
    GIDSignIn.sharedInstance().signIn()
  }

  override func viewDidLoad() {
      super.viewDidLoad()
      locationManager.requestAlwaysAuthorization()

      
    
     //  Google Sign in
      GIDSignIn.sharedInstance()?.presentingViewController = self
      GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    
      // App need to run in background
    
  }
}

