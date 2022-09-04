//
//  ErrorType.swift
//  TDD_JuiceMaker
//
//  Created by 서녕 on 2022/09/04.
//

import Foundation

enum ErrorType: Error {
    case outOfStock
    
    enum LimitError: Error {
    case maximumLimit
    case minimumLimit
    }
}
