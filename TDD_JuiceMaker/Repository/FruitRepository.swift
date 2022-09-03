//
//  Repository.swift
//  TDD_JuiceMaker
//
//  Created by 서녕 on 2022/09/02.
//

import Foundation
import RxSwift

class FruitRepository: Repository {
    private var stock = [Fruit: Int]()
    private let initialStock: Int
    
    init(initialStock: Int) {
        self.initialStock = initialStock
        
        Fruit.allCases.forEach { fruit in
            stock.updateValue(self.initialStock, forKey: fruit)
        }
    }
    
    func readStock(of fruit: Fruit) throws -> Observable<Int> {
        guard let fruitStock = self.stock[fruit] else {
            throw ErrorType.readError
        }
        return Observable.just(fruitStock)
    }
    
    func updateStock(of fruit: Fruit, newValue: Int) {
        self.stock.updateValue(newValue, forKey: fruit)
    }
}


enum ErrorType: Error {
    case readError
    case outOfStock
}
