//  Restaurant.swift
//  SweetDeal

import Foundation

class Restaurant {
  var name: String
  var phone: String
  var imageURL: String
  var categories: String?
  var street_address: String?
  var city: String?
  var state: String?
  var zip: String?
//  var longitude: Float
//  var latitude: Float
  
  //Simple constructor for select restaurant page
  init(name: String, phone: String, imageURL: String) {
    self.name = name
    self.phone = phone
    self.imageURL = imageURL
  }
  
  //Full constructor
  init(name: String, phone: String, imageURL: String, categories: String, street_address: String, city: String, state: String, zip: String) {
    self.name = name
    self.phone = phone
    self.imageURL = imageURL
    self.categories = categories
    self.street_address = street_address
    self.city = city
    self.state = state
    self.zip = zip
  }

}

