//  CollegeDec.swift
//  SweetDeal

import Foundation

struct CollegeRes: Decodable {
    let address: String
    let city: String
    let latitude: Float
    let longitude: Float
    let state: String
    let zip: Int
    let name: String
    
    enum CodingKeys : String, CodingKey {
        case address = "ADDRESS"
        case city = "CITY"
        case latitude = "Lat"
        case longitude = "Long"
        case state = "STATE"
        case zip = "ZIP"
        case name = "name"
        
    }
}
