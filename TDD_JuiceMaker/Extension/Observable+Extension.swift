//
//  Observable+Extension.swift
//  TDD_JuiceMaker
//
//  Created by 서녕 on 2022/09/04.
//

import Foundation
import RxSwift

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map{ _ in }
    }
}
