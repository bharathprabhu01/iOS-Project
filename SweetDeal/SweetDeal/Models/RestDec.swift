//  ResRest.swift
//  SweetDeal

import Foundation

struct Rest: Decodable {
    let image_url: String
    let name: String
    let phone: String
    
    enum CodingKeys : String, CodingKey {
        case image_url
        case name
        case phone
    }
}
