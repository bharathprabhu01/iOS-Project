//
//  DealDec.swift
//  SweetDeal

import Foundation

struct DealRes: Decodable {
    let description: String
    let name: String
    let restaurantsID: [String]
    let valid_until: String
    
    enum CodingKeys : String, CodingKey {
        case description
        case name
        case restaurantsID = "restID"
        case valid_until
        
    }
}
