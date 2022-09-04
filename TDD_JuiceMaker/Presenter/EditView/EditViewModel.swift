//
//  EditViewModel.swift
//  TDD_JuiceMaker
//
//  Created by 서녕 on 2022/09/04.
//

import Foundation
import RxSwift

final class EditViewModel {
    private let juiceMaker = JuiceMaker()
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let strawberryStepperValueChanged: Observable<Double>
        let bananaStepperValueChanged: Observable<Double>
        let pineappleStepperValueChanged: Observable<Double>
        let kiwiStepperValueChanged: Observable<Double>
        let mangoStepperValueChanged: Observable<Double>
    }
    
    struct Output {
        let strawberryStock: Observable<Int>
        let bananaStock: Observable<Int>
        let pineappleStock: Observable<Int>
        let kiwiStock: Observable<Int>
        let mangoStock: Observable<Int>
    }
    
    func transform(input: Input) -> Output {
        let strawberryStepperTap = input.strawberryStepperValueChanged
            .skip(1)
            .map(Int.init)
            .do(onNext: { stepperValue in
                self.juiceMaker.updateFruitStock(of: .strawberry, newQuantity: stepperValue)
            })
            .share()
        
        let bananaStepperTap = input.bananaStepperValueChanged
            .skip(1)
            .map(Int.init)
            .do(onNext: { stepperValue in
                self.juiceMaker.updateFruitStock(of: .banana, newQuantity: stepperValue)
            })
            .share()
        
        let pineappleStepperTap = input.pineappleStepperValueChanged
            .skip(1)
            .map(Int.init)
            .do(onNext: { stepperValue in
                self.juiceMaker.updateFruitStock(of: .pineapple, newQuantity: stepperValue)
            })
            .share()
                    
        let kiwiStepperTap = input.kiwiStepperValueChanged
            .skip(1)
            .map(Int.init)
            .do(onNext: { stepperValue in
                self.juiceMaker.updateFruitStock(of: .kiwi, newQuantity: stepperValue)
            })
            .share()
                        
        let mangoStepperTap = input.mangoStepperValueChanged
            .skip(1)
            .map(Int.init)
            .do(onNext: { stepperValue in
                self.juiceMaker.updateFruitStock(of: .mango, newQuantity: stepperValue)
            })
            .share()

        let strawberryStock = Observable.merge(
            input.viewWillAppear,
            strawberryStepperTap.mapToVoid()
        ).flatMap{ _ in
            self.juiceMaker.fetchFruitStock(.strawberry)
        }
        
        let bananaStock = Observable.merge(
            input.viewWillAppear,
            bananaStepperTap.mapToVoid()
        ).flatMap{ _ in
            self.juiceMaker.fetchFruitStock(.banana)
        }
        
        let pineappleStock = Observable.merge(
            input.viewWillAppear,
            pineappleStepperTap.mapToVoid()
        ).flatMap{ _ in
            self.juiceMaker.fetchFruitStock(.pineapple)
        }
        
        let kiwiStock = Observable.merge(
            input.viewWillAppear,
            kiwiStepperTap.mapToVoid()
        ).flatMap{ _ in
            self.juiceMaker.fetchFruitStock(.kiwi)
        }
        
        let mangoStock = Observable.merge(
            input.viewWillAppear,
            mangoStepperTap.mapToVoid()
        )
            .flatMap{ self.juiceMaker.fetchFruitStock(.mango) }
        
        return Output(strawberryStock: strawberryStock,
                      bananaStock: bananaStock,
                      pineappleStock: pineappleStock,
                      kiwiStock: kiwiStock,
                      mangoStock: mangoStock)
    }
}
