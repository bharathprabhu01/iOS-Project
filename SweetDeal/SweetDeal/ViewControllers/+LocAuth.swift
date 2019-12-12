//
//  +LocAuth.swift
//  SweetDeal
//
//  Created by Bharath Prabhu on 12/11/19.
//
import UIKit
import CoreLocation
import UserNotifications
import MapKit

extension StuMainViewController {
    
    // Show pop-up if user changes location authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.authorizedWhenInUse) {
            showLocationDisabledPopUp()
        }
    }
    
    // pop-up function
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to give you the best deals, we always need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
        }
    }
    
    func createGeoFence(restaurant: Restaurant) {
        let resName = restaurant.name
        let resLong = restaurant.longitude!
        let resLat = restaurant.latitude!
        let geoFenceRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(CLLocationDegrees(resLat), CLLocationDegrees(resLong)), radius: 20, identifier: "\(resName)")
        self.locationManager.startMonitoring(for: geoFenceRegion)
    }
  
  func postLocalNotifications(eventTitle: String) {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    
    content.title = eventTitle
    content.body = "Tap the notification to see more details"
    content.sound = UNNotificationSound.default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    
    let notificationRequest:UNNotificationRequest = UNNotificationRequest(identifier: "Blah", content: content, trigger: trigger)
    
    center.add(notificationRequest, withCompletionHandler: { (error) in
      if let error = error {
        print(error)
      }
      else{
        print("Added")
      }
    })
  }
  
  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    print("Entered: \(region.identifier)")
    postLocalNotifications(eventTitle: "An Offer From \(region.identifier)!")
  }
  
  func requestPermissionNotifications() {
      let application =  UIApplication.shared
      
      if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self as! UNUserNotificationCenterDelegate
          
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (isAuthorized, error) in
              if(error != nil) {
                  print(error!)
              }
              else{
                  if(isAuthorized) {
                      print("authorized")
                      NotificationCenter.default.post(Notification(name: Notification.Name("AUTHORIZED")))
                  }
                  else{
                      let pushPreference = UserDefaults.standard.bool(forKey: "PREF_PUSH_NOTIFICATIONS")
                      if pushPreference == false {
                          let alert = UIAlertController(title: "Turn on Notifications", message: "Push notifications are turned off.", preferredStyle: .alert)
                          alert.addAction(UIAlertAction(title: "Turn on notifications", style: .default, handler: { (alertAction) in
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                  return
                              }
                              
                              if UIApplication.shared.canOpenURL(settingsUrl) {
                                  UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                      // Checking for setting is opened or not
                                      print("Setting is opened: \(success)")
                                  })
                              }
                              UserDefaults.standard.set(true, forKey: "PREF_PUSH_NOTIFICATIONS")
                          }))
                          alert.addAction(UIAlertAction(title: "No thanks.", style: .default, handler: { (actionAlert) in
                              print("user denied")
                              UserDefaults.standard.set(true, forKey: "PREF_PUSH_NOTIFICATIONS")
                          }))
                          let viewController = UIApplication.shared.keyWindow!.rootViewController
                          DispatchQueue.main.async {
                              viewController?.present(alert, animated: true, completion: nil)
                          }
                      }
                  }
              }
          }
      }
      else {
          let settings: UIUserNotificationSettings =
              UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
      }
  }
  
}
