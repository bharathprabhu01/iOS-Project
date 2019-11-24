//
//  RestaurantList.swift
//  SweetDeal
//
//  Created by Sandy Pan on 11/23/19.

import Foundation
import Firebase
//import UIKit

// Database instance
var ref = Database.database().reference()

//protocol DataModelDelegate: class {
//  func didRecieveDataUpdate(data: [Restaurant])
//}


class RestaurantList {
//  static let sharedInstance = RestaurantList()
//  fileprivate init(){}
  
//  weak var delegate: DataModelDelegate?
  var finalArray : [Restaurant]
  
  init() {
    finalArray = [Restaurant]()
  }
  
//  func requestData() {
//    // the data was received and parsed to String
//    let data = self.finalArray
//    delegate?.didRecieveDataUpdate(data: data)
//  }

  func getRestaurants() {
    var name: String!
    var phone: String!
  //  var price: String
  //  var rating: Int
  //  var reviewCount: Int
    var imageURL: String!
//    var tempArr = [Restaurant]()
    
    ref.child("Restaurants").observeSingleEvent(of: .value, with: { (snapshot) in
      if let resList = snapshot.value as? [String: AnyObject] {
        for (key, obj) in resList {
          //restaurant name
          if let tempName = obj["name"] {
            if let resName = tempName as? String{
             name = resName
            }
          }
          //restaurant phone number
          if let tempNum = obj["phone"] {
            if let resNum = tempNum as? String{
              phone = resNum
            }
          }
          //restaurant image
          if let tempImage = obj["image_url"] {
            if let imageurl = tempImage as? String {
              imageURL = imageurl
            }
          }
          let res = Restaurant(name:name, phone:phone, imageURL: imageURL)
          self.finalArray.append(res)
        }
      }
    })
//    return tempArr
//    OperationQueue.main.addOperation {
//      completion()
//    }
//    completion()
  }
//
////  func refresh(completion: @escaping () -> Void) {
////    client.fetchRepositories { [unowned self] data in
////
////      // we need in this block a way for the parser to get an array of repository
////      // objects (if they exist) and then set the repos var in the view model to
////      // those repository objects
////      if let repos=self.parser.repositoriesFromSearchResponse(data) {
////        self.repos = repos
////      }
////      completion()
////    }
////  }
//  
//  func requestData(completion: @escaping () -> Void) {
//    let data = getRestaurants()
//    self.finalArray = data
//    completion()
//  }
  
}
