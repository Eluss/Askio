//
//  DayInfoViewController.swift
//  Askio
//
//  Created by Eliasz Sawicki on 19/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import UIKit
import AskioCore
import ReactiveSwift
import ReactiveCocoa

class DayInfoViewController: UIViewController {
    
    private let viewModel: DayInfoViewModel
    
    private var painLabel: UILabel!
    private var painSwitch: UISwitch!
    private var painSlider: UISlider!
    
    private var menstruationLabel: UILabel!
    private var menstruationSwitch: UISwitch!
    private var menstruationSlider: UISlider!
    
    
    private var stackView: UIStackView!
    private var disposables = CompositeDisposable()
    
    init(viewModel: DayInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    private func setupViewController() {
        createComponents()
        addViewsToSuperview()
        applyConstraints()
        setupObservers()
    }
    
    func save() {
        viewModel.save()
    }
    
    private func setupObservers() {
        disposables += viewModel.title.producer.startWithValues {[unowned self] (title) in
            self.title = title
        }
        
        disposables += viewModel.hasPain <~ painSwitch.reactive.isOnValues
        disposables += viewModel.hasMenstruation <~ menstruationSwitch.reactive.isOnValues
        
        disposables += painSwitch.reactive.isOn <~ viewModel.hasPain
        disposables += menstruationSwitch.reactive.isOn <~ viewModel.hasMenstruation
        
        disposables += viewModel.painLevel <~ painSlider.reactive.values.map { value -> LevelScale in
            return LevelScale(rawValue: Int(value)) ?? .none
        }
        disposables += painSlider.reactive.value <~ viewModel.painLevel.producer.map({ (levelScale) -> Float in
            if levelScale.rawValue <= 0 {
                return 1
            }
            return Float(levelScale.rawValue)
        })
        
        disposables += viewModel.menstruationLevel <~ menstruationSlider.reactive.values.map { value -> LevelScale in
            return LevelScale(rawValue: Int(value)) ?? .none
        }
        disposables += menstruationSlider.reactive.value <~ viewModel.menstruationLevel.producer.map({ (levelScale) -> Float in
            if levelScale.rawValue <= 0 {
                return 1
            }
            return Float(levelScale.rawValue)
        })
        
        disposables += painSlider.reactive.isHidden <~ viewModel.hasPain.map { !$0 }
        disposables += menstruationSlider.reactive.isHidden <~ viewModel.hasMenstruation.map { !$0 }
    }
    
    private func createComponents() {
        view.backgroundColor = .white
        painLabel = createLabel(with: viewModel.painTitle)
        menstruationLabel = createLabel(with: viewModel.menstruationTitle)
        painSwitch = createSwitch()
        painSlider = createSlider()
        menstruationSlider = createSlider()
        stackView = createStackView()
        menstruationSwitch = createSwitch()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
    }
    
    private func createSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = viewModel.minScaleLevel
        slider.maximumValue = viewModel.maxScaleLevel
        slider.reactive.value <~ slider.reactive.values.map { roundf($0) }
        return slider
    }
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }
    
    private func createLabel(with title: String, fontSize: CGFloat = 15) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        return label
    }
    
    private func createSwitch() -> UISwitch {
        let switchControl = UISwitch()
        return switchControl
    }
    
    private func addViewsToSuperview() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(painLabel)
        stackView.addArrangedSubview(painSwitch)
        stackView.addArrangedSubview(painSlider)
        stackView.addArrangedSubview(menstruationLabel)
        stackView.addArrangedSubview(menstruationSwitch)
        stackView.addArrangedSubview(menstruationSlider)
    }
    
    private func applyConstraints() {
        stackView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(menstruationSlider.snp.bottom)
        }
        
        painSlider.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(20)
        }
        
        menstruationSlider.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(20)
        }
        
    }
    
    
}
