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

final class FruitRepositoryTests: XCTestCase {
    private var repository: MockFruitRepository!
    private var testData = [Fruit: Int]()
    private var testFruit: Fruit!
    
    override func setUp() {
        self.testData = [.strawberry: 10,
                          .banana: 15,
                          .pineapple: 20,
                          .kiwi: 30,
                          .mango: 40]
        self.repository = MockFruitRepository(data: self.testData)
        self.testFruit = .banana
    }
    
    func test_readStock() {
        let observable = repository.readStock(of: testFruit)
            .toBlocking()
        let result = try! observable.single()
        let expectation = testData[testFruit]

        XCTAssertEqual(result, expectation)
    }
    
    func test_updateStock() {
        let newValue = 20

        repository.updateStock(of: testFruit, newValue: newValue)
        
       let observable = repository.readStock(of: testFruit)
            .toBlocking()
        let result = try! observable.single()
        let expectation = newValue
        
        XCTAssertEqual(result, expectation)
        repository.verifyReadStock(of: testFruit, readStockResult: newValue)
    }
    
    func test_decreaseStock() {
        let decreaseCount = 1
        
        try! repository.decreaseStock(of: testFruit, by: decreaseCount)
        
        let observable = repository.readStock(of: testFruit)
             .toBlocking()
        let result = try! observable.single()
        let expectation = testData[testFruit]! - decreaseCount
        
        XCTAssertEqual(result, expectation)
        repository.verifyReadStock(of: testFruit, readStockResult: testData[testFruit]! - decreaseCount)
    }
    
    func test_outOfStockError() {
        let decreaseCount = testData[testFruit]! + 1
        
        XCTAssertThrowsError(try repository.decreaseStock(of: testFruit, by: decreaseCount)) {
            XCTAssertEqual($0 as! ErrorType, ErrorType.outOfStock)
        }
    }
}
