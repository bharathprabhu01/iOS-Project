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
  var review_count: Int?
  var rating: Float?
  var hours: [Hour]?
  var id: String
  
  
  //Simple constructor for select restaurant page
  init(name: String, phone: String, imageURL: String, id: String) {
    self.name = name
    self.phone = phone
    self.imageURL = imageURL
    self.id = id
  }
  
  //Full constructor
    init(name: String, phone: String, imageURL: String, categories: String, street_address: String, city: String, state: String, zip: String, longitude: Float, latitude: Float, price: String, review_count: Int, rating: Float, hours: [Hour], id: String) {
      self.name = name
      self.phone = phone
      self.imageURL = imageURL
      self.categories = categories
      self.street_address = street_address
      self.city = city
      self.state = state
      self.zip = zip
      self.categories = categories
      self.longitude = longitude
      self.latitude = latitude
      self.price = price
      self.review_count = review_count
      self.rating = rating
      self.hours = hours
      self.id = id
  }

}

