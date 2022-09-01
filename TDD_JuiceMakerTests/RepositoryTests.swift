//
//  TDD_JuiceMakerTests.swift
//  TDD_JuiceMakerTests
//
//  Created by 서녕 on 2022/09/02.
//

import XCTest
@testable import TDD_JuiceMaker

class RepositoryTests: XCTestCase {
    var stock: [String: Int]!

    override func setUp() {
        self.stock = ["딸기":10, "바나나": 5]
    }

    func test_updateStock() {
        let result = stock.updateValue(100, forKey: "딸기")
        let expectation = 100
        
        XCTAssertEqual(result, expectation)
    }
    
    func test_readStock() {
        let result = self.stock["딸기"]
        let expectation = 10
        
        XCTAssertEqual(result, expectation)
    }

}
