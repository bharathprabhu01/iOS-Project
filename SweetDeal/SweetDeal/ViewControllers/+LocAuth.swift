import UIKit
import CoreLocation
import UserNotifications
import MapKit

extension ViewController {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // change this as necessary
//            print(location.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.authorizedWhenInUse) {
          print(status)
            showLocationDisabledPopUp()
        }
    }

    func showLocationDisabledPopUp() {
        print("GOT HERE")
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

}
