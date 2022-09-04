//
//  JuiceMaker.swift
//  TDD_JuiceMaker
//
//  Created by 서녕 on 2022/09/03.
//

import Foundation
import RxSwift

struct JuiceMaker {
    private var fruitRepository: Repository
    
    init() {
        let repository = FruitRepository.shared
        self.fruitRepository = repository
    }
    
    func fetchFruitStock(_ fruit: Fruit ) -> Observable<Int> {
        return self.fruitRepository.readStock(of: fruit)
    }
    
    func makeJuice(_ juice: Juice) -> Observable<Juice> {
        let makeResult = self.haveAllIngredients(for: juice)
            .do(onNext: { canMake in
                guard canMake else {
                    return
                }
                self.decreaseFruitStock(for: juice)
            })
            .flatMap { bool in
                Observable<Juice>.create{ emitter in
                    switch bool {
                    case true:
                        emitter.onNext(juice)
                    case false:
                        emitter.onError(ErrorType.outOfStock)
                    }
                    return Disposables.create()
                }
            }
        
        return makeResult
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
    
    func decreaseFruitStock(for juice: Juice) {
        juice.recipe.forEach{ requiredFruit, requiredCount in
            self.fruitRepository.decreaseStock(of: requiredFruit, by: requiredCount)
        }
    }
    
    func updateFruitStock(of fruit: Fruit, newQuantity: Int){
        self.fruitRepository.updateStock(of: fruit, newValue: newQuantity)
    }
}
