//
//  JuiceMakerTests.swift
//  TDD_JuiceMakerTests
//
//  Created by 서녕 on 2022/09/02.
//

import XCTest
import RxSwift
import RxBlocking
@testable import TDD_JuiceMaker

final class JuiceMakerTests: XCTestCase {
    private var testJuice: Juice!
    private var testFruitStock: [Fruit: Int]!
    private var juiceMaker: JuiceMaker!
    private var disposeBag = DisposeBag()
    
    override func setUp() {
        testFruitStock = [.strawberry: 10,
                          .banana: 10,
                          .pineapple: 10,
                          .kiwi: 10,
                          .mango: 10]
        self.testJuice = .bananaJuice
        
        let repository = MockFruitRepository(data: testFruitStock)
        self.juiceMaker = JuiceMaker(fruitRepository: repository)
    }
    
    func test_makeJuice() {
        let observable = juiceMaker.makeJuice(testJuice)
            .toBlocking()
        let result = try! observable.single()
        let expectation = testJuice
        
        XCTAssertEqual(result, expectation)
    }
    
    func test_haveAllIngredients() {
        let observable = juiceMaker.haveAllIngredients(for: testJuice)
            .toBlocking()
        let result = try! observable.single()
        let expectation = testJuice.recipe.map{ requiredFruit, requiredCount in
            requiredCount <= testFruitStock[requiredFruit]! ? true : false
        }
            .contains(false) ? false : true

        XCTAssertEqual(result, expectation)
    }
    
    func test_haveFruitStock() {
        let result = juiceMaker.haveFruitStock(for: testJuice)
            .map{ observable in
                try! observable.toBlocking().single()
            }
        let expectation = testJuice.recipe.map{ requiredFruit, requiredCount in
            requiredCount <= testFruitStock[requiredFruit]! ? true : false
        }
        
        XCTAssertEqual(result, expectation)
  }
}
