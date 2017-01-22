//
//  LevelScaleView.swift
//  Askio
//
//  Created by Eliasz Sawicki on 20/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import AskioCore
import SnapKit

class LevelScaleView: UIView {
    
    private var levelScale: Property<LevelScale>
    private var stackView: UIStackView!
    private var circles = [UIView]()
    private var color: UIColor
    private var circleSize: CGSize
    private var disposables = CompositeDisposable()
    private var stackViewRightConstraint: Constraint?
    
    init(levelScale: Property<LevelScale>, color: UIColor, circleSize: CGSize) {
        self.levelScale = levelScale
        self.color = color
        self.circleSize = circleSize
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        createComponents()
        addViewsToSuperview()
        applyConstraints()
        setupObservers()
    }
    
    private func setupObservers() {
        disposables += levelScale.producer.observe(on: QueueScheduler.main).startWithValues {[unowned self] scale in
            let numberOfCircles = scale.rawValue < 0 ? 0 : scale.rawValue
            self.displayCircles(count: numberOfCircles)            
        }
    }
    
    private func displayCircles(count: Int) {
        circles.forEach { (view) in
            view.removeFromSuperview()
        }
        circles = [UIView]()
        for _ in 0..<count {
            circles.append(createCircle())
        }
        circles.forEach { (view) in
            stackView.addArrangedSubview(view)
        }
        stackViewRightConstraint?.deactivate()
        if circles.count > 0 {
            
            stackView.snp.makeConstraints { (make) in
                stackViewRightConstraint = make.right.equalTo(circles.last!.snp.right).constraint
            }
        }
    }
    
    private func createCircle() -> UIView {
        let circle = UIView()
        circle.backgroundColor = color
        circle.layer.cornerRadius = circleSize.width / 2
        
        circle.snp.makeConstraints { (make) in
           make.size.equalTo(circleSize)
        }
        return circle
    }
    
    private func createComponents() {
        stackView = createStackView()
    }
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        return stackView
    }
    
    private func addViewsToSuperview() {
        addSubview(stackView)
    }
    
    private func applyConstraints() {
        stackView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
    }
    
    deinit {
        disposables.dispose()
    }
}
