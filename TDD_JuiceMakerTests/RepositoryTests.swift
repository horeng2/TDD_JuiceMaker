//
//  TDD_JuiceMakerTests.swift
//  TDD_JuiceMakerTests
//
//  Created by 서녕 on 2022/09/02.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import TDD_JuiceMaker

class RepositoryTests: XCTestCase {
    var repository: Repository!
    var initialStock = 20
    let scheduler = TestScheduler(initialClock: 0)


    override func setUp() {
        self.repository  = Repository(initialStock: initialStock)
    }
    
    func test_readStock() {
        let observable = try! self.repository
            .readStock(of: .strawberry)
            .toBlocking()
        
        let result = try! observable.single()
        let expectation = initialStock

        
        XCTAssertEqual(result, expectation)
    }
    
    func test_updateStock() {
        self.repository.updateStock(of: .strawberry, newValue: 1)

        let observable = try! self.repository
            .readStock(of: .strawberry)
            .toBlocking()

        let updatedValue = try! observable.single()
        let expectation = 1
        XCTAssertEqual(updatedValue, expectation)
    }
}
