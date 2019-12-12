//
//  SweetDealTests.swift
//  SweetDealTests
//
//  Created by Bharath Prabhu on 11/3/19.
//

import XCTest
@testable import SweetDeal

class SweetDealTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
      
  
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
  
  func testCollege(){
    let testCollege = College(name: "Boston University", address: "1000 Mass Ave", city: "Boston", state: "MA", lat: Float(40.333), long: Float(32.99), zip: 12390)
    XCTAssert(type(of: testCollege)==College.self)
  }
  
  func testDeal(){
    let testDeal = Deal(description: "15% off Sandwiches", id: "Deal51", name: "SandwichDiscount", valid_until: "nil", restaurant: "Exchange")
    XCTAssert(type(of: testDeal)==Deal.self)
  }

}
