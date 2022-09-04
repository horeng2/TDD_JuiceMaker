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
    
    func readStock(of fruit: Fruit) -> Observable<Int> {
        let fruitStock = self.stockData[fruit]!
        return Observable.just(fruitStock)
    }
    
    func updateStock(of fruit: Fruit, newValue: Int) -> Observable<Bool> {
        guard newValue < 100 else {
            return Observable.error(ErrorType.LimitError.maximumLimit)
        }
        guard newValue > 0 else {
            return Observable.error(ErrorType.LimitError.minimumLimit)
        }
        
        self.stockData.updateValue(newValue, forKey: fruit)
        
        return Observable.just(true)
    }
    
    func decreaseStock(of fruit: Fruit, by count: Int) {
        guard let currentStock = self.stockData[fruit],
              currentStock - count > .zero else {
            return
        }
        self.stockData.updateValue(currentStock - count, forKey: fruit)
    }
    
    func verifyReadStock(of fruit: Fruit, readStockResult: Int) {
        XCTAssertEqual(self.stockData[fruit], readStockResult)
    }
    
    func verifyUpdateStock(of fruit: Fruit, newValue: Int) {
        XCTAssertEqual(self.stockData[fruit], newValue)
    }
    
    func verifydecreaseStock(of fruit: Fruit, newValue: Int) {
        XCTAssertEqual(self.stockData[fruit], newValue)
    }
}
