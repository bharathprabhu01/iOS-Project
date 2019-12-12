//
//  AppDelegate.swift
//  SweetDeal
//
//  Created by Bharath Prabhu on 11/3/19.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
  var sr = StuResViewController()
  var window: UIWindow?
  var ref: DatabaseReference!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    FirebaseApp.configure()
    GIDSignIn.sharedInstance().clientID = "318021857036-791l2cpodesfjkhlafejqq632vbrgol9.apps.googleusercontent.com"
    GIDSignIn.sharedInstance().delegate = self
    return true
  }

  @available(iOS 9.0, *)
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    return GIDSignIn.sharedInstance().handle(url)
  }

  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
            withError error: Error!) {
    if let error = error {
      if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
        print("The user has not signed in before or they have since signed out.")
      } else {
        print("\(error.localizedDescription)")
      }
      return
    }
 
    ref = Database.database().reference()
    //pulling information from Google Sign in
    let userID = user.userID!
    let idToken = user.authentication!.idToken
    let firstName = user.profile!.givenName!
    let lastName = user.profile!.familyName!
    let email = user.profile!.email!
//
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let sc = storyboard.instantiateViewController(withIdentifier: "StuResViewController") as! StuResViewController
//    sc.currUserID = userID
//    sc.currUserFN = firstName
//    sc.currUserLN = lastName
//    sc.currUserEmail = email
//    self.window!.rootViewController = sc
//    self.window!.makeKeyAndVisible()
    //

    //Linking to the right page
    
    
    ref.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
      //user exists already
      if snapshot.hasChild(userID) {
        //user is a student"
        let value = snapshot.value as? NSDictionary
        let content = value![userID] as? NSDictionary
        let type = content!["is_student"] as? NSValue
        if type != nil {
          print("HI I'm a student somehow")
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let sc = storyboard.instantiateViewController(withIdentifier: "StuMainViewController") as! StuMainViewController
          sc.currUserID = userID
          sc.currUserFN = firstName
          sc.currUserLN = lastName
          sc.currUserEmail = email
          self.window!.rootViewController = sc
          self.window!.makeKeyAndVisible()
          //is a res owner
        } else {
          print("HI IM AN OWNERS")
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let sc = storyboard.instantiateViewController(withIdentifier: "ResMainViewController") as! ResMainViewController
          sc.currUserID = userID
          sc.currUserFN = firstName
          sc.currUserLN = lastName
          sc.currUserEmail = email
          
//          self.ref.child("Users")
          let myres = content!["restaurant"] as? NSDictionary
          let resName = myres!["name"] as! NSString
          let resPhone = myres!["phone"] as! NSString
          let resImage = myres!["imageURL"] as! NSString
          let resID = myres!["id"] as! NSString
          let myresobj = Restaurant(name: String(resName), phone: String(resPhone), imageURL: String(resImage), id: String(resID))
          sc.myRes = myresobj
          
          
          
          // get res obj here big sad :(
          self.window!.rootViewController = sc
          self.window!.makeKeyAndVisible()
        }
        //new user
      } else {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sc = storyboard.instantiateViewController(withIdentifier: "StuResViewController") as! StuResViewController
        sc.currUserID = userID
        sc.currUserFN = firstName
        sc.currUserLN = lastName
        sc.currUserEmail = email
        self.window!.rootViewController = sc
        self.window!.makeKeyAndVisible()
        // Add new signed-in user to database
        self.ref.child("Users").child(userID).setValue(["idToken": idToken, "firstName": firstName, "lastName": lastName, "email": email])
      }
    })
  }
  
  func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
            withError error: Error!) {
    // Perform any operations when the user disconnects from app here.
  }



  func applicationWillResignActive(_ application: UIApplication) {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
      // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      // Saves changes in the application's managed object context before the application terminates.
      self.saveContext()
  }

  // MARK: - Core Data stack

  lazy var persistentContainer: NSPersistentContainer = {
      /*
       The persistent container for the application. This implementation
       creates and returns a container, having loaded the store for the
       application to it. This property is optional since there are legitimate
       error conditions that could cause the creation of the store to fail.
      */
      let container = NSPersistentContainer(name: "SweetDeal")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            
              /*
               Typical reasons for an error here include:
               * The parent directory does not exist, cannot be created, or disallows writing.
               * The persistent store is not accessible, due to permissions or data protection when the device is locked.
               * The device is out of space.
               * The store could not be migrated to the current model version.
               Check the error message to determine what the actual problem was.
               */
              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
  }()

  // MARK: - Core Data Saving support

  func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
          do {
              try context.save()
          } catch {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
      }
  }

}

