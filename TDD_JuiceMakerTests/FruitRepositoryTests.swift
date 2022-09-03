//
//  TDD_JuiceMakerTests.swift
//  TDD_JuiceMakerTests
//
//  Created by 서녕 on 2022/09/02.
//

import XCTest
import RxSwift
import RxBlocking
@testable import TDD_JuiceMaker

class FruitRepositoryTests: XCTestCase {
    var testData = [Fruit: Int]()
    var testFruit: Fruit!

    override func setUp() {
        Fruit.allCases.forEach { fruit in
            self.testData.updateValue(10, forKey: fruit)
        }
        self.testFruit = .strawberry
    }
    
    func test_readStock() {
        let observable = Observable.just(testData[testFruit])
            .toBlocking()

        let result = try! observable.single()
        let expectation = testData[testFruit]

        XCTAssertEqual(result, expectation)
    }
    
    func test_updateStock() {
        let newValue = 20
        testData.updateValue(newValue, forKey: testFruit)
        
        XCTAssertEqual(newValue, testData[testFruit])
    }
    
    func decreaseStock(of fruit: Fruit, by count: Int) throws {
        guard let currentStock = self.testData[fruit] else {
            throw ErrorType.readError
        }
        guard currentStock > .zero else {
            throw ErrorType.outOfStock
        }
        self.testData.updateValue(currentStock - count, forKey: fruit)
        
        XCTAssertEqual(currentStock - count, testData[fruit])
    }
}
