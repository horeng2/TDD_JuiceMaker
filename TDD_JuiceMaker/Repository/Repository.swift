//
//  Repository.swift
//  TDD_JuiceMaker
//
//  Created by 서녕 on 2022/09/02.
//

import Foundation

class Repository {
    private var stock = [Fruit: Int]()
    private let initialStock: Int
    
    init(initialStock: Int) {
        self.initialStock = initialStock
        
        Fruit.allCases.forEach { fruit in
            stock.updateValue(self.initialStock, forKey: fruit)
        }
    }
    
    func readStock() -> [Fruit: Int] {
        return self.stock
    }
    
    func updateStock(of fruit: Fruit, newValue: Int) {
        self.stock.updateValue(newValue, forKey: fruit)
    }
}
