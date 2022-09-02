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
    let scheduler = TestScheduler(initialClock: 0)
    let initialStock = 10

    var repository: Repository!
    var testData = [Fruit: Int]()
    var testFruit: Fruit!

    override func setUp() {
        self.repository  = Repository(initialStock: initialStock)
        self.testFruit = .strawberry

        Fruit.allCases.forEach { fruit in
            self.testData.updateValue(self.initialStock, forKey: fruit)
        }
    }
    
    func test_readStock() {
        let observable = try! repository
            .readStock(of: testFruit)
            .toBlocking()
        
        let result = try! observable.single()
        let expectation = testData[testFruit]

        XCTAssertEqual(result, expectation)
    }
    
    func test_updateStock() {
        repository.updateStock(of: testFruit, newValue: 1)
        testData.updateValue(1, forKey: testFruit)
        
        let observable = try! repository
            .readStock(of: testFruit)
            .toBlocking()

        let updatedValue = try! observable.single()
        let expectation = testData[testFruit]
        
        XCTAssertEqual(updatedValue, expectation)
    }
}
