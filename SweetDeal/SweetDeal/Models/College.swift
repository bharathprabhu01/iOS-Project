//  College.swift
//  SweetDeal

import Foundation

class College {
  var name: String
  var address: String
  var city: String
  var state: String
  var lat: Float
  var long: Float
  var zip: Int
  
  init(name: String, address: String, city: String, state: String, lat: Float, long: Float, zip: Int) {
    self.name = name
    self.address = address
    self.city = city
    self.state = state
    self.lat = lat
    self.long = long
    self.zip = zip
  }
  
}
