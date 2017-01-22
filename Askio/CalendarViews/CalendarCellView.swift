//
//  CalendarCellView.swift
//  Askio
//
//  Created by Eliasz Sawicki on 11/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import JTAppleCalendar
import SnapKit
import AskioCore
import ReactiveCocoa
import ReactiveSwift

class CalendarCellView: JTAppleDayCellView {
    
    let viewModel: CalendarCellViewModel
    private let dayLabel = UILabel()
    private let circle = UIView()
    private var painLevelScaleView: LevelScaleView!
    private var menstruationLevelScaleView: LevelScaleView!
    private var disposables = CompositeDisposable()
    
    convenience init() {
        let viewModel = CalendarCellDefaultViewModel()
        self.init(viewModel: viewModel)
    }
    
    init(viewModel: CalendarCellViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        layer.cornerRadius = 10
        createComponents()
        addViewsToSuperview()
        applyConstraints()
        setupObservers()
    }
    
    private func setupObservers() {
        disposables += dayLabel.reactive.text <~ viewModel.dayText
        
        disposables += viewModel.belongsToCurrentMonth.producer.startWithValues {[unowned self] (isCurrentMonth) in
            if isCurrentMonth {
                self.circle.backgroundColor = UIColor.green.withAlphaComponent(0.4)
            } else {
                self.circle.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func createComponents() {
        dayLabel.font = UIFont.boldSystemFont(ofSize: 15)
        dayLabel.textAlignment = .center
        
        circle.layer.cornerRadius = 20
        circle.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        
        painLevelScaleView = LevelScaleView(levelScale: viewModel.painLevel, color: UIColor.blue.withAlphaComponent(0.5), circleSize: CGSize(width: 7, height: 7))
        menstruationLevelScaleView = LevelScaleView(levelScale: viewModel.menstruationLevel, color: UIColor.red.withAlphaComponent(0.5), circleSize: CGSize(width: 7, height: 7))
    }
    
    private func applyConstraints() {
        circle.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        dayLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        painLevelScaleView.snp.makeConstraints { (make) in
            make.bottom.equalTo(dayLabel.snp.top)
            make.height.equalTo(20)
            make.left.right.equalToSuperview().inset(10)
        }
        
        menstruationLevelScaleView.snp.makeConstraints { (make) in
            make.top.equalTo(dayLabel.snp.bottom)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
    }
    
    private func addViewsToSuperview() {
        addSubview(circle)
        addSubview(dayLabel)
        addSubview(painLevelScaleView)
        addSubview(menstruationLevelScaleView)
    }
    
    deinit {
        disposables.dispose()
    }
}
