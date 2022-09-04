//
//  EditViewModel.swift
//  TDD_JuiceMaker
//
//  Created by 서녕 on 2022/09/04.
//

import Foundation
import RxSwift

final class EditViewModel {
    private let juiceMaker: JuiceMaker
    
    init(repository: Repository) {
        self.juiceMaker = JuiceMaker(fruitRepository: repository)
    }
    
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
        let limitStockAlertMessage: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        let strawberryTapAction = self.updateStepperValue(fruit: .strawberry, input: input)
        let bananaTapAction = self.updateStepperValue(fruit: .banana, input: input)
        let pineappleTapAction = self.updateStepperValue(fruit: .pineapple, input: input)
        let kiwiTapAction = self.updateStepperValue(fruit: .kiwi, input: input)
        let mangoTapAction = self.updateStepperValue(fruit: .mango, input: input)
        
        let strawberryStock = Observable.merge(
            input.viewWillAppear,
            strawberryTapAction.mapToVoid()
        ).flatMap{ _ in
            self.juiceMaker.fetchFruitStock(.strawberry)
        }
        
        let bananaStock = Observable.merge(
            input.viewWillAppear,
            bananaTapAction.mapToVoid()
        ).flatMap{ _ in
            self.juiceMaker.fetchFruitStock(.banana)
        }
        
        let pineappleStock = Observable.merge(
            input.viewWillAppear,
            pineappleTapAction.mapToVoid()
        ).flatMap{ _ in
            self.juiceMaker.fetchFruitStock(.pineapple)
        }
        
        let kiwiStock = Observable.merge(
            input.viewWillAppear,
            kiwiTapAction.mapToVoid()
        ).flatMap{ _ in
            self.juiceMaker.fetchFruitStock(.kiwi)
        }
        
        let mangoStock = Observable.merge(
            input.viewWillAppear,
            mangoTapAction.mapToVoid()
        ).flatMap{ _ in
            self.juiceMaker.fetchFruitStock(.mango)
        }
        
        
        let limitStockAlertMessage = PublishSubject<String>()
        
        let _ = Observable.merge(
            strawberryTapAction,
            bananaTapAction,
            pineappleTapAction,
            kiwiTapAction,
            mangoTapAction
        ).do(onError: { error in
            let limitError = error as! ErrorType.LimitError
            let message: String = {
                switch limitError{
                case .maximumLimit:
                    return LimitStockAlert.maximumStock.message
                case .minimumLimit:
                    return LimitStockAlert.minimumStock.message
                }
            }()
            limitStockAlertMessage.onNext(message)
        })
            .retry()
        
        return Output(strawberryStock: strawberryStock,
                      bananaStock: bananaStock,
                      pineappleStock: pineappleStock,
                      kiwiStock: kiwiStock,
                      mangoStock: mangoStock,
                      limitStockAlertMessage: limitStockAlertMessage)
    }
    
    func updateStepperValue(fruit: Fruit, input: Input) -> Observable<Bool> {
        let stepperObservable: Observable<Int> = {
            switch fruit {
            case .strawberry:
                return input.strawberryStepperValueChanged
                    .map(Int.init)
            case .banana:
                return input.bananaStepperValueChanged
                    .map(Int.init)
            case .pineapple:
                return input.pineappleStepperValueChanged
                    .map(Int.init)
            case .kiwi:
                return input.kiwiStepperValueChanged
                    .map(Int.init)
            case .mango:
                return input.mangoStepperValueChanged
                    .map(Int.init)
            }
        }()
        
        let updateSuccess = stepperObservable
            .flatMap{ stepperValue in
                self.juiceMaker.updateFruitStock(of: fruit, newQuantity: stepperValue)
            }
        
        return updateSuccess
    }
    
    enum LimitStockAlert {
        var message: String {
            switch self {
            case .maximumStock:
                return "재고가 바닥났어요📦"
            case .minimumStock:
                return "재고가 꽉찼습니다. 배불러요🐷"
            }
        }
        
        case maximumStock
        case minimumStock
    }
}
