import Foundation

class DealRequest {
    
    // API Calls
    let resourceUrl:URL
    let API_KEY = "US_AFF_0_201236_212556_0"
    
    var limit = 10
    var result: Result?
    
    init(){
        let resourceString = "https://partner-api.groupon.com/deals.json?tsToken=[\(self.API_KEY)]&filters=category%3Afood-and-drink&limit=\(limit)&fbclid=IwAR0xIZ9wJVuzya3RHdQwAD1aBKXASjGgUZklsqoeKaHsCL6_H5o8ZOGje80"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceUrl = resourceURL
    }
}
