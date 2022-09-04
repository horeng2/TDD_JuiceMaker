//
//  OrderViewModel.swift
//  TDD_JuiceMaker
//
//  Created by 서녕 on 2022/09/04.
//

import Foundation
import RxSwift

final class OrderViewModel {
    private let juiceMaker: JuiceMaker
    
    init() {
        let repository = FruitRepository()
        self.juiceMaker = JuiceMaker(fruitRepository: repository)
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let strawBananaJuiceButtonDidTap: Observable<Void>
        let mangoKiwiJuiceButtonDidTap: Observable<Void>
        let strawberryJuiceButtonDidTap: Observable<Void>
        let bananaJuiceButtonDidTap: Observable<Void>
        let pineappleJuiceButtonDidTap: Observable<Void>
        let kiwiJuiceButtonDidTap: Observable<Void>
        let mangoJuiceButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let strawberryStock: Observable<String>
        let bananaStock: Observable<String>
        let pineappleStock: Observable<String>
        let kiwiStock: Observable<String>
        let mangoStock: Observable<String>
        let orderResultMessage: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        let orderResultMessage = PublishSubject<String>()
        
        let strawBananaJuiceTapAction = input.strawBananaJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.strawberryBananaJuice) }
            .do(onNext: { juice in
                let message = OrderResult.orderSuccess(juice: juice).message
                orderResultMessage.onNext(message)
            }, onError: { error in
                let message = OrderResult.orderFailure.message
                orderResultMessage.onNext(message)
            })
            .retry()
                
        let mangoKiwiJuiceTapAction = input.mangoKiwiJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.mangoKiwiJuice) }
            .do(onNext: { juice in
                let message = OrderResult.orderSuccess(juice: juice).message
                orderResultMessage.onNext(message)
            }, onError: { error in
                let message = OrderResult.orderFailure.message
                orderResultMessage.onNext(message)
            })
            .retry()
                
        let strawberryJuiceTapAction = input.strawberryJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.strawberryJuice) }
            .do(onNext: { juice in
                let message = OrderResult.orderSuccess(juice: juice).message
                orderResultMessage.onNext(message)
            }, onError: { error in
                let message = OrderResult.orderFailure.message
                orderResultMessage.onNext(message)
            })
            .retry()
                
        let bananaJuiceTapAction = input.bananaJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.bananaJuice) }
            .do(onNext: { juice in
                let message = OrderResult.orderSuccess(juice: juice).message
                orderResultMessage.onNext(message)
            }, onError: { error in
                let message = OrderResult.orderFailure.message
                orderResultMessage.onNext(message)
            })
            .retry()
                        
        let pineappleJuiceTapAction = input.pineappleJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.pineappleJuice) }
            .do(onNext: { juice in
                let message = OrderResult.orderSuccess(juice: juice).message
                orderResultMessage.onNext(message)
            }, onError: { error in
                let message = OrderResult.orderFailure.message
                orderResultMessage.onNext(message)
            })
            .retry()
                
        let kiwiJuiceTapAction = input.kiwiJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.kiwiJuice) }
            .do(onNext: { juice in
                let message = OrderResult.orderSuccess(juice: juice).message
                orderResultMessage.onNext(message)
            }, onError: { error in
                let message = OrderResult.orderFailure.message
                orderResultMessage.onNext(message)
            })
            .retry()
                                
        let mangoJuiceTapAction = input.mangoJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.mangoJuice) }
            .do(onNext: { juice in
                let message = OrderResult.orderSuccess(juice: juice).message
                orderResultMessage.onNext(message)
            }, onError: { error in
                let message = OrderResult.orderFailure.message
                orderResultMessage.onNext(message)
            })
            .retry()
                                        
        let strawberryStock = Observable.merge(
            input.viewWillAppear,
            strawBananaJuiceTapAction.mapToVoid(),
            strawberryJuiceTapAction.mapToVoid()
        ).flatMap { _ in
            self.fecthFruitStockToString(of: .strawberry)
        }
                
        let bananaStock = Observable.merge(
            input.viewWillAppear,
            strawBananaJuiceTapAction.mapToVoid(),
            bananaJuiceTapAction.mapToVoid()
        ).flatMap { _ in
            self.fecthFruitStockToString(of: .banana)
        }
                                        
        let pineappleStock = Observable.merge(
            input.viewWillAppear,
            pineappleJuiceTapAction.mapToVoid()
        ).flatMap { _ in
            self.fecthFruitStockToString(of: .pineapple)
        }
                
        let kiwiStock = Observable.merge(
            input.viewWillAppear,
            mangoKiwiJuiceTapAction.mapToVoid(),
            kiwiJuiceTapAction.mapToVoid()
        ).flatMap { _ in
            self.fecthFruitStockToString(of: .kiwi)
        }
                                        
        let mangoStock = Observable.merge(
            input.viewWillAppear,
            mangoKiwiJuiceTapAction.mapToVoid(),
            mangoJuiceTapAction.mapToVoid()
        ).flatMap { _ in
            self.fecthFruitStockToString(of: .mango)
        }
                
        return Output(strawberryStock: strawberryStock,
                      bananaStock: bananaStock,
                      pineappleStock: pineappleStock,
                      kiwiStock: kiwiStock,
                      mangoStock: mangoStock,
                      orderResultMessage: orderResultMessage)
    }
    
    func fecthFruitStockToString(of fruit: Fruit) -> Observable<String> {
        return self.juiceMaker.fetchFruitStock(fruit).map(String.init)
    }
    
    enum OrderResult {
        var message: String {
            switch self {
            case .orderSuccess(let juice):
                return "\(juice.koreaName) 주문 완료🥤"
            case .orderFailure:
                return "주문 실패! 재고가 부족해요💦"
            }
        }
        
        case orderSuccess(juice: Juice)
        case orderFailure
    }
}


