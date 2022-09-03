//
//  JuiceMaker.swift
//  TDD_JuiceMaker
//
//  Created by 서녕 on 2022/09/03.
//

import Foundation
import RxSwift

struct JuiceMaker {
    var fruitRepository: Repository
    
    init(fruitRepository: Repository) {
        self.fruitRepository = fruitRepository
    }
    
    func fetchFruitStock(_ fruit: Fruit ) -> Observable<Int> {
        return self.fruitRepository.readStock(of: fruit)
    }
    
    func makeJuice(_ juice: Juice) -> Observable<Bool> {
        let makeResult = self.haveAllIngredients(for: juice)
            .do(onNext: { canMake in
                guard canMake else {
                    return
                }
                self.decreaseFruitStock(for: juice)
            })
        return makeResult
    }
    
    func decreaseFruitStock(for juice: Juice) {
        juice.recipe.forEach{ requiredFruit, requiredCount in
            do {
                try self.fruitRepository.decreaseStock(of: requiredFruit, by: requiredCount)
            } catch {
                print(error)
            }
        }
    }
    
    func haveAllIngredients(for juice: Juice) -> Observable<Bool> {
        let haveFruitStock = self.haveFruitStock(for: juice)
        return Observable.zip(haveFruitStock) { haveFruit in
            haveFruit.contains(false) ? false : true
        }
    }
    
    func haveFruitStock(for juice: Juice) -> [Observable<Bool>] {
        return juice.recipe.map{ requiredFruit, requiredCount in
            self.fruitRepository.readStock(of: requiredFruit)
                .map{ currentStock -> Bool in
                    return currentStock >= requiredCount
                }
        }
    }
}
