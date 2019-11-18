import Foundation

// Structs

// Result just returns a list of deals
struct Result: Decodable {
    let deals: [Deal]
    
    enum CodingKeys : String, CodingKey {
        case deals
    }
}

//Deal is where most information about what the deal actually is
struct Deal: Decodable {
    let id:String
    let title:String
    let shortAnnouncementTitle:String
    let options: [Option] //This is where we get the option
    let merchant: Merchant //This is where to get the information about the restaurant
    
    enum CodingKeys : String, CodingKey {
        case id
        case title = "announcementTitle"
        case shortAnnouncementTitle
        case options
        case merchant
    }
}

//Get the restaurant name
struct Merchant: Decodable {
    let name:String
    
    enum CodingKeys : String, CodingKey {
        case name
    }
}

//Get the restaurant from parsing through option
struct Option: Decodable {
    let redemptionLocations:[Location]
    
    enum CodingKeys : String, CodingKey {
        case redemptionLocations
    }
}

//Get the location of the restaurant where the deal can be reclaimed
struct Location: Decodable {
    let streetAddress1:String
    let state:String
    let city:String
    let zip:String
    let country:String
    let lat:Float
    let lng:Float
    
    enum CodingKeys : String, CodingKey {
        case streetAddress1
        case state
        case city
        case zip = "postalCode"
        case country
        case lat
        case lng
    }
}

