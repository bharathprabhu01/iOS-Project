
import Foundation

class Deal {
  var description: String
  var id: String
  var name: String
  var valid_until: String
  var restaurant: String
  
  init(description: String, id: String, name: String, valid_until: String, restaurant: String){
    self.description = description
    self.id = id
    self.name = name
    self.valid_until = valid_until
    self.restaurant = restaurant
  }
}
