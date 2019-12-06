//  ResRest.swift
//  SweetDeal

import Foundation

struct Rest: Decodable {
    let image_url: String?
    let name: String?
    let phone: String?
    let display_phone: String?
    let price: String?
    let rating: Float?
    let review_count: Int?
    let id: String
    
    let categories: [Title]?
    let coordinates: Coordinate?
    let hours: [Hour]?
    let location: Location?
    
    enum CodingKeys : String, CodingKey {
        case image_url
        case name
        case phone
        case display_phone
        case price
        case rating
        case review_count
        case categories
        case coordinates
        case hours
        case location
        case id
    }
}

struct Title: Decodable {
    let title: String?
    
    enum CodingKeys : String, CodingKey {
        case title
    }
}

struct Coordinate: Decodable {
    let latitude: Float?
    let longitude: Float?
    
    enum CodingKeys : String, CodingKey {
        case latitude
        case longitude
    }
}

struct Hour: Decodable {
    let day: Int?
    let end: String?
    
    enum CodingKeys : String, CodingKey {
        case day
        case end
    }
}

struct Location: Decodable {
    let address1: String?
    let address2: String?
    let address3: String?
    let city: String?
    let state: String?
    let zipcode: String?
    let display_address: [String]?
    
    enum CodingKeys : String, CodingKey {
        case address1
        case address2
        case address3
        case city
        case state
        case zipcode = "zip_code"
        case display_address
    }
}

