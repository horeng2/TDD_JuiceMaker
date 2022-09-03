//
//  MockFruitRepository.swift
//  TDD_JuiceMakerTests
//
//  Created by 서녕 on 2022/09/03.
//

import XCTest
import RxSwift
@testable import TDD_JuiceMaker

final class MockFruitRepository: Repository {
    private var stockData: [Fruit: Int]
    
    init(data: [Fruit: Int]) {
        self.stockData = data
    }
    
    func readStock(of fruit: Fruit) throws -> Observable<Int> {
        guard let fruitStock = self.stockData[fruit] else {
            throw ErrorType.readError
        }
        return Observable.just(fruitStock)
    }
    
    func updateStock(of fruit: Fruit, newValue: Int) {
        self.stockData.updateValue(newValue, forKey: fruit)
    }
    
    func verifyReadStock(of fruit: Fruit, readStockResult: Int) {
        XCTAssertEqual(self.stockData[fruit], readStockResult)
    }
    
    func verifyUpdateStock(of fruit: Fruit, newValue: Int) {
        XCTAssertEqual(self.stockData[fruit], newValue)
    }
}