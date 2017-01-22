//
//  SettingsViewController.swift
//  Askio
//
//  Created by Eliasz Sawicki on 22/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import UIKit
import AskioCore
import ReactiveSwift
import ReactiveCocoa

class SettingsViewController: UIViewController {
    
    private var viewModel: SettingsViewModel
    private var titleLabel: UILabel!
    private var notificationSwitch: UISwitch!
    private var timePicker: UIDatePicker!
    private var disposables = CompositeDisposable()
    private var toggleNotificationcocoaAction: CocoaAction<UISwitch>!
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = viewModel.screenTitle
        setupViewController()
    }
    
    private func setupViewController() {
        createComponents()
        addViewsToSuperview()
        applyConstraints()
        setupObservers()
    }
    
    private func setupObservers() {
        disposables += viewModel.pickedDate <~ timePicker.reactive.dates
        disposables += timePicker.reactive.date <~ viewModel.pickedDate
        disposables += viewModel.isNotificationOn <~ notificationSwitch.reactive.isOnValues
        disposables += notificationSwitch.reactive.isOn <~ viewModel.isNotificationOn
        toggleNotificationcocoaAction = CocoaAction(viewModel.toggleNotification, {[unowned self] (switchControl) -> (Bool, Date?) in
            let isOn = switchControl.isOn
            return (isOn, self.viewModel.pickedDate.value)
        })
        notificationSwitch.reactive.toggled = toggleNotificationcocoaAction
        disposables += timePicker.reactive.isEnabled <~ viewModel.isNotificationOn.producer.map { !$0 }
    }
    
    private func createComponents() {
        titleLabel = createTitleLabel()
        timePicker = createPicker()
        notificationSwitch = createSwitch()
    }
    
    private func createSwitch() -> UISwitch {
        let switchControl = UISwitch()
        return switchControl
    }
    
    private func createPicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        return datePicker
    }
    
    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = viewModel.timerTitle
        return label
    }
    
    private func addViewsToSuperview() {
        view.addSubview(titleLabel)
        view.addSubview(timePicker)
        view.addSubview(notificationSwitch)
    }
    
    private func applyConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(50)
        }
        
        timePicker.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
        }
        
        notificationSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(timePicker.snp.bottom).inset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    deinit {
        disposables.dispose()
    }

}
