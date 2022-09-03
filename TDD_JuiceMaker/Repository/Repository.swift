//
//  Repository.swift
//  TDD_JuiceMaker
//
//  Created by 서녕 on 2022/09/03.
//

import Foundation
import RxSwift

protocol Repository {
    func readStock(of fruit: Fruit) -> Observable<Int>
    func updateStock(of fruit: Fruit, newValue: Int)
    func decreaseStock(of fruit: Fruit, by count: Int) throws
}
