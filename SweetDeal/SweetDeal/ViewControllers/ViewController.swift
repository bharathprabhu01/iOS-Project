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
      locationManager.requestAlwaysAuthorization()
    
     //  Google Sign in
      GIDSignIn.sharedInstance()?.presentingViewController = self
      GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    
      // App need to run in background
    
    
    if CLLocationManager.locationServicesEnabled() {
      self.locationManager.delegate = self
      self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
      self.locationManager.startUpdatingLocation()
      self.locationManager.distanceFilter = 10
      self.locationManager.allowsBackgroundLocationUpdates = true
                   
                   
      let geoFenceRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(CLLocationDegrees(40.44342739985601), CLLocationDegrees(-79.94474458436478)), radius: 5, identifier: "Gates")
      self.locationManager.startMonitoring(for: geoFenceRegion)
                 
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
      postLocalNotifications(eventTitle: "An Offer From Me!")
  }
  
//  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//    if let location = locations.first {
//      // change this as necessary
//      print("main", location.coordinate)
//    }
//
//    let notification = UILocalNotification()
//    notification.alertBody = "location updated"
//    notification.fireDate = Date()
//    UIApplication.shared.scheduleLocalNotification(notification)
//
//  }
  
  
  func postLocalNotifications(eventTitle:String) {
       let center = UNUserNotificationCenter.current()
       
       let content = UNMutableNotificationContent()
       content.title = eventTitle
       content.body = "Tap the notification to see the details"
       content.sound = UNNotificationSound.default
       
       let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
       
       let notificationRequest:UNNotificationRequest = UNNotificationRequest(identifier: "Blah", content: content, trigger: trigger)
       
       center.add(notificationRequest, withCompletionHandler: { (error) in
           if let error = error {
               // Something went wrong
               print(error)
           }
           else{
               print("added")
           }
       })
   }
   
}

