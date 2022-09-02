//
//  JuiceMakerTests.swift
//  TDD_JuiceMakerTests
//
//  Created by 서녕 on 2022/09/02.
//

import XCTest
import RxSwift
@testable import TDD_JuiceMaker

class JuiceMakerTests: XCTestCase {
    var repository: Repository!
    let diposeBag = DisposeBag()

    override func setUp() {
    }
    
    func test_makeJuice(_ juice: Juice) throws {
    }
    
    func test_takeStock(for juice: Juice) throws {
        juice.recipe.forEach{ fruit in
            
        }
    }
    
    func test_updateStock() {

    }
}
