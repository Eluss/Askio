//
//  CalendarHeaderView.swift
//  Askio
//
//  Created by Eliasz Sawicki on 19/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import JTAppleCalendar
import AskioCore
import ReactiveSwift
import ReactiveCocoa

class CalendarHeaderView: JTAppleHeaderView {

    let viewModel: CalendarHeaderViewModel
    private let disposables = CompositeDisposable()
    
    private let titleLabel = UILabel()
    
    convenience init() {
        let viewModel = CalendarHeaderDefaultViewModel()
        self.init(viewModel: viewModel)
    }
    
    init(viewModel: CalendarHeaderViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        createComponents()
        addViewsToSuperview()
        applyConstraints()
        setupObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupObservers() {
        disposables += titleLabel.reactive.text <~ viewModel.title
    }
    
    private func createComponents() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.textAlignment = .center
    }
    
    private func applyConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    private func addViewsToSuperview() {
        addSubview(titleLabel)
    }
    
    deinit {
        disposables.dispose()
    }
    
}
