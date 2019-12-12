//
//  DealDec.swift
//  SweetDeal

import Foundation

struct DealRes: Decodable {
  let id: String
    let description: String
    let name: String
    let restaurantsID: String
    let valid_until: String
    
    enum CodingKeys : String, CodingKey {
        case id
        case description
        case name
        case restaurantsID = "restID"
        case valid_until
        
    }
}
