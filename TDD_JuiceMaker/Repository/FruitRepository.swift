//
//  Repository.swift
//  TDD_JuiceMaker
//
//  Created by 서녕 on 2022/09/02.
//

import Foundation
import RxSwift

final class FruitRepository: Repository {
    private var stockData = [Fruit: Int]()
    private let initialStock = 10
    private let maximumStock = 100
    private let minimumStock = 0
    
    init() {
        Fruit.allCases.forEach { fruit in
            stockData.updateValue(self.initialStock, forKey: fruit)
        }
    }
    
    func readStock(of fruit: Fruit) -> Observable<Int> {
        let fruitStock = self.stockData[fruit]!
        return Observable.just(fruitStock)
    }
    
    func updateStock(of fruit: Fruit, newValue: Int) -> Observable<Bool> {
        guard newValue < self.maximumStock else {
            return Observable.error(ErrorType.LimitError.maximumLimit)
        }
        guard newValue > self.minimumStock else {
            return Observable.error(ErrorType.LimitError.minimumLimit)
        }
        
        self.stockData.updateValue(newValue, forKey: fruit)
        
        return Observable.just(true)
    }
    
    func decreaseStock(of fruit: Fruit, by count: Int) {
        guard let currentStock = self.stockData[fruit],
              currentStock - count >= .zero else {
            return
        }
        self.stockData.updateValue(currentStock - count, forKey: fruit)
    }
}



