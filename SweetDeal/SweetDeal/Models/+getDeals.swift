import Foundation

extension DealRequest {
    
    func getDeals(completion: @escaping (_ result:Result?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: resourceUrl) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            
            // Decode the JSON here
            if let temp_result = try? JSONDecoder().decode(Result.self, from: data) {
                completion(temp_result)
            }
            else {
                return
            }
        }
        task.resume()
    }
    
}

