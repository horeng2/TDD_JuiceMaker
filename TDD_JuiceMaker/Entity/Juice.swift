//
//  Juice.swift
//  TDD_JuiceMaker
//
//  Created by 서녕 on 2022/09/02.
//

import Foundation

enum Juice {
    var recipe: Dictionary<Fruit, Int> {
        switch self {
        case .strawberryJuice:
            return [.strawberry: 16]
        case .bananaJuice:
            return [.banana: 2]
        case .kiwiJuice:
            return [.kiwi: 3]
        case .pineappleJuice:
            return [.pineapple: 2]
        case .strawberryBananaJuice:
            return [.strawberry: 10, .banana: 1]
        case .mangoJuice:
            return [.mango: 3]
        case .mangoKiwiJuice:
            return [.mango: 2, .kiwi: 1]
        }
    }
    
    var koreaName: String {
        switch self {
        case .strawberryBananaJuice:
            return "딸바주스"
        case .mangoKiwiJuice:
            return "망키주스"
        case .strawberryJuice:
            return "딸기주스"
        case .bananaJuice:
            return "바나나주스"
        case .pineappleJuice:
            return "파인애플주스"
        case .kiwiJuice:
            return "키위주스"
        case .mangoJuice:
            return "망고주스"
        }
    }
    
    case strawberryBananaJuice
    case mangoKiwiJuice
    case strawberryJuice
    case bananaJuice
    case pineappleJuice
    case kiwiJuice
    case mangoJuice
}
