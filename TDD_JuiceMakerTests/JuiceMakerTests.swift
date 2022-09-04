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
        self.testJuice = .strawberryBananaJuice
        
        let repository = MockFruitRepository(data: testFruitStock)
        self.juiceMaker = JuiceMaker(fruitRepository: repository)
    }
    
    func test_makeJuice() {
        let observable = juiceMaker.makeJuice(testJuice)
            .do(onError: { error in
                XCTAssertEqual(error as! ErrorType, ErrorType.outOfStock)
            })
            .retry()
            .toBlocking()
        let result = try! observable.single()
        let expectation = testJuice
        
        XCTAssertEqual(result, expectation)
    }
    
    func test_decreaseFruitStock() {
        let repository = MockFruitRepository(data: testFruitStock)
        
        testJuice.recipe.forEach{ requiredFruit, requiredCount in
            repository.decreaseStock(of: requiredFruit, by: requiredCount)
        }
        
        
        var current = [Fruit: Int]()
        
        testJuice.recipe.forEach{ requiredFruit, requiredCount in
           let stockObservable = repository.readStock(of: requiredFruit)
                .toBlocking()
            let stock = try! stockObservable.single()
            current.updateValue(stock, forKey: requiredFruit)
        }
        
        var correct = testJuice.recipe
        
        let _ = correct.compactMap{ requiredFruit, requiredCount in
            correct.updateValue(testFruitStock[requiredFruit]! - requiredCount, forKey: requiredFruit)
        }
        
        XCTAssertEqual(current, correct)
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
