import UIKit
import CoreLocation
import UserNotifications
import MapKit
import GoogleSignIn

class ViewController: UIViewController, CLLocationManagerDelegate {
//  let locationManager = CLLocationManager()
  
    
  @IBAction func googleSignInClicked(_ sender: GIDSignInButton) {
//    sender.setTitle("Sign in with Google", for: .normal)
     GIDSignIn.sharedInstance().signIn()
    
  }

  override func viewDidLoad() {
      super.viewDidLoad()
//      locationManager.requestAlwaysAuthorization()
//
//      if CLLocationManager.locationServicesEnabled() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//      }
    
     //  Google Sign in
      GIDSignIn.sharedInstance()?.presentingViewController = self
      GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    
      // App need to run in background
    
  }
}

