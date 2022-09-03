//
//  OrderViewModel.swift
//  TDD_JuiceMaker
//
//  Created by 서녕 on 2022/09/04.
//

import Foundation
import RxSwift

final class OrderViewModel {
    private let juiceMaker = JuiceMaker(fruitRepository: FruitRepository())
    
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
        let orderResultMessage: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let strawBananaJuiceMakingResult = input.strawBananaJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.strawberryBananaJuice) }
            .share()
        
        let mangoKiwiJuiceMakingResult = input.mangoKiwiJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.mangoKiwiJuice) }
            .share()
        
        let strawberryJuiceMakingResult = input.strawberryJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.strawberryJuice) }
            .share()
        
        let bananaJuiceMakingResult = input.bananaJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.bananaJuice) }
            .share()
        
        let pineappleJuiceMakingResult = input.pineappleJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.pineappleJuice) }
            .share()
        
        let kiwiJuiceMakingResult = input.kiwiJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.kiwiJuice) }
            .share()
        
        let mangoJuiceMakingResult = input.mangoJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.mangoJuice) }
            .share()
        
        let orderResultMessage = Observable.merge(
            strawBananaJuiceMakingResult,
            mangoKiwiJuiceMakingResult,
            strawberryJuiceMakingResult,
            bananaJuiceMakingResult,
            pineappleJuiceMakingResult,
            kiwiJuiceMakingResult,
            mangoJuiceMakingResult
        )
            .map{ makeJuiceResult in
                OrderResult(makeJuiceResult).message
            }

        let strawberryStock = Observable.merge(
            input.viewWillAppear,
            strawBananaJuiceMakingResult.mapToVoid(),
            strawberryJuiceMakingResult.mapToVoid()
        ).flatMap { _ in
            self.fecthFruitStockToString(of: .strawberry)
        }
        
        let bananaStock = Observable.merge(
            input.viewWillAppear,
            strawBananaJuiceMakingResult.mapToVoid(),
            strawberryJuiceMakingResult.mapToVoid()
        ).flatMap { _ in
            self.fecthFruitStockToString(of: .banana)
        }
        
        let pineappleStock = Observable.merge(
            input.viewWillAppear,
            strawBananaJuiceMakingResult.mapToVoid(),
            strawberryJuiceMakingResult.mapToVoid()
        ).flatMap { _ in
            self.fecthFruitStockToString(of: .pineapple)
        }
        
        let kiwiStock = Observable.merge(
            input.viewWillAppear,
            strawBananaJuiceMakingResult.mapToVoid(),
            strawberryJuiceMakingResult.mapToVoid()
        ).flatMap { _ in
            self.fecthFruitStockToString(of: .kiwi)
        }
        
        let mangoStock = Observable.merge(
            input.viewWillAppear,
            strawBananaJuiceMakingResult.mapToVoid(),
            strawberryJuiceMakingResult.mapToVoid()
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
            case .orderSuccess:
                return "주스 주문 완료🥤"
            case .orderFailure:
                return "주문 실패! 재고가 부족해요💦"
            }
        }
        
        init(_ makeJuiceResult: Bool) {
            switch makeJuiceResult {
            case true:
                self = .orderSuccess
            case false:
                self = .orderFailure
            }
        }
        
        case orderSuccess
        case orderFailure
    }
    
}


