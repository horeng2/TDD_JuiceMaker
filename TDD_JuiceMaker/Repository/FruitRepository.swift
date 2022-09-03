//
//  Repository.swift
//  TDD_JuiceMaker
//
//  Created by 서녕 on 2022/09/02.
//

import Foundation
import RxSwift

class FruitRepository: Repository {
    private var stockData = [Fruit: Int]()
    private let initialStock: Int
    
    init(initialStock: Int) {
        self.initialStock = initialStock
        
        Fruit.allCases.forEach { fruit in
            stockData.updateValue(self.initialStock, forKey: fruit)
        }
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
    
    func decreaseStock(of fruit: Fruit, by count: Int) throws {
        guard let currentStock = self.stockData[fruit] else {
            return
        }
        guard currentStock - count > .zero else {
            throw ErrorType.outOfStock
        }
        self.stockData.updateValue(currentStock - count, forKey: fruit)
    }
}


enum ErrorType: Error {
    case readError
    case outOfStock
}
