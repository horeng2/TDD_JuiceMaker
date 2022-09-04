//
//  Repository.swift
//  TDD_JuiceMaker
//
//  Created by 서녕 on 2022/09/02.
//

import Foundation
import RxSwift

final class FruitRepository: Repository {
    static let shared = FruitRepository()
    private var stockData = [Fruit: Int]()
    private let initialStock = 10
    static let maximumStock = 100
    static let minimumStock = 0
    
    init() {
        Fruit.allCases.forEach { fruit in
            stockData.updateValue(self.initialStock, forKey: fruit)
        }
    }
    
    func readStock(of fruit: Fruit) -> Observable<Int> {
        let fruitStock = self.stockData[fruit]!
        return Observable.just(fruitStock)
    }
    
    func updateStock(of fruit: Fruit, newValue: Int){
        guard newValue <= FruitRepository.maximumStock,
              newValue >= FruitRepository.minimumStock else {
            return
        }
        self.stockData.updateValue(newValue, forKey: fruit)
    }
    
    func decreaseStock(of fruit: Fruit, by count: Int) {
        guard let currentStock = self.stockData[fruit],
              currentStock - count >= FruitRepository.minimumStock else {
            return
        }
        self.stockData.updateValue(currentStock - count, forKey: fruit)
    }
}



