//
//  EditViewController.swift
//  TDD_JuiceMaker
//
//  Created by 서녕 on 2022/09/04.
//

import UIKit
import RxSwift

class EditViewController: UIViewController {
    @IBOutlet weak var strawberryStockLabel: UILabel!
    @IBOutlet weak var bananaStockLabel: UILabel!
    @IBOutlet weak var pineappleStockLabel: UILabel!
    @IBOutlet weak var kiwiStockLabel: UILabel!
    @IBOutlet weak var mangoStockLabel: UILabel!
    
    @IBOutlet weak var strawberryStepper: UIStepper!
    @IBOutlet weak var bananaStepper: UIStepper!
    @IBOutlet weak var pineappleStepper: UIStepper!
    @IBOutlet weak var kiwiStepper: UIStepper!
    @IBOutlet weak var mangoStepper: UIStepper!
        
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.binding()
    }
    
    private func binding() {
        let editViewModel = EditViewModel()
        let input = EditViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))).map{ _ in },
            strawberryStepperValueChanged: self.strawberryStepper.rx.value.asObservable(),
            bananaStepperValueChanged: self.bananaStepper.rx.value.asObservable(),
            pineappleStepperValueChanged: self.pineappleStepper.rx.value.asObservable(),
            kiwiStepperValueChanged: self.kiwiStepper.rx.value.asObservable(),
            mangoStepperValueChanged: self.mangoStepper.rx.value.asObservable()
        )
        let output = editViewModel.transform(input: input)
        
        output.strawberryStock
            .bind(onNext: { stock in
                self.strawberryStockLabel.text = String(stock)
                self.strawberryStepper.value = Double(stock)
            })
            .disposed(by: self.disposeBag)

        output.bananaStock
            .bind(onNext: { stock in
                self.bananaStockLabel.text = String(stock)
                self.bananaStepper.value = Double(stock)
            })
            .disposed(by: self.disposeBag)
        
        output.pineappleStock
            .bind(onNext: { stock in
                self.pineappleStockLabel.text = String(stock)
                self.pineappleStepper.value = Double(stock)
            })
            .disposed(by: self.disposeBag)
        
        output.kiwiStock
            .bind(onNext: { stock in
                self.kiwiStockLabel.text = String(stock)
                self.kiwiStepper.value = Double(stock)
            })
            .disposed(by: self.disposeBag)
        
        output.mangoStock
            .bind(onNext: { stock in
                self.mangoStockLabel.text = String(stock)
                self.mangoStepper.value = Double(stock)
            })
            .disposed(by: self.disposeBag)
        
        self.setStepperLimitValue()
    }
    
    func setStepperLimitValue() {
        let maximumValue = Double(FruitRepository.maximumStock)
        let minimumValue = Double(FruitRepository.minimumStock)
        
        self.strawberryStepper.maximumValue = maximumValue
        self.bananaStepper.maximumValue = maximumValue
        self.pineappleStepper.maximumValue = maximumValue
        self.kiwiStepper.maximumValue = maximumValue
        self.mangoStepper.maximumValue = maximumValue
        
        self.strawberryStepper.minimumValue = minimumValue
        self.bananaStepper.minimumValue = minimumValue
        self.pineappleStepper.minimumValue = minimumValue
        self.kiwiStepper.minimumValue = minimumValue
        self.mangoStepper.minimumValue = minimumValue
    }
}
