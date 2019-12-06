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
  var longitude: Float?
  var latitude: Float?
  var price: String?
  var review_count: String?
  var rating: String?
  var hours: String?
  var id: String?
    
  
  //Simple constructor for select restaurant page
  init(name: String, phone: String, imageURL: String) {
    self.name = name
    self.phone = phone
    self.imageURL = imageURL
  }
  
  //Full constructor
    init(name: String, phone: String, imageURL: String, categories: String, street_address: String, city: String, state: String, zip: String, longitude: Float, latitude: Float, price: String, review_count: String, rating: String, hours: String, id: String) {
    self.name = name
    self.phone = phone
    self.imageURL = imageURL
    self.categories = categories
    self.street_address = street_address
    self.city = city
    self.state = state
    self.zip = zip
    self.longitude = longitude
    self.latitude = latitude
    self.categories = categories
    self.hours = hours
    self.id = id
  }

}

