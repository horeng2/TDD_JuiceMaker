//
//  TDD_JuiceMakerTests.swift
//  TDD_JuiceMakerTests
//
//  Created by 서녕 on 2022/09/02.
//

import XCTest
@testable import TDD_JuiceMaker

class RepositoryTests: XCTestCase {
    var repository: Repository!
    var initialStock = 20

    override func setUp() {
        self.repository  = Repository(initialStock: initialStock)
    }
    
    func test_readStock() {
        Fruit.allCases.forEach{ fruit in
            let result = self.repository.readStock()[fruit]
            let expectation = self.initialStock
            
            XCTAssertEqual(result, expectation)
        }
    }
    
    func test_updateStock() {
        self.repository.updateStock(of: .strawberry, newValue: 1)
        
        let result = self.repository.readStock()[.strawberry]
        let expectation = 1
        
        XCTAssertEqual(result, expectation)
    }
}
