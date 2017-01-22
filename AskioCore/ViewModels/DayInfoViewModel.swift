//
//  DayInfoViewModel.swift
//  Askio
//
//  Created by Eliasz Sawicki on 19/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import ReactiveSwift

public protocol DayInfoViewModel {


    var title: Property<String> { get }
    var painTitle: String { get }
    var menstruationTitle: String { get }
    var hasPain: MutableProperty<Bool> { get }
    var hasMenstruation: MutableProperty<Bool> { get }
    var painLevel: MutableProperty<LevelScale> {get}
    var menstruationLevel: MutableProperty<LevelScale> {get}
    var minScaleLevel: Float {get}
    var maxScaleLevel: Float {get}

    func apply(_ date: Date)

    func save()
}

public class DayInfoDefaultViewModel: DayInfoViewModel {

    private var date: Date = Date()
    private var dayInfo: DayInfo?

    private var _title = MutableProperty("")
    public var title: Property<String>
    public var painTitle: String = "Ból:"
    public var menstruationTitle: String = "Menstruacja:"

    public var hasPain = MutableProperty<Bool>(false)
    public var hasMenstruation = MutableProperty<Bool>(false)
    public var painLevel = MutableProperty(LevelScale.none)
    public var menstruationLevel = MutableProperty(LevelScale.none)
    public var minScaleLevel: Float = 1
    public var maxScaleLevel: Float = 3

    private var dayInfoRepository: DayInfoRepository
    private var disposables = CompositeDisposable()

    public var onClose: ((Date) -> ())?

    public init(dayInfoRepository: DayInfoRepository) {
        self.dayInfoRepository = dayInfoRepository
        title = Property(_title)
        setupObservers()
    }
    
    private func setupObservers() {
        disposables += hasPain.producer.startWithValues {[unowned self] hasPain in
            self.painLevel.value = hasPain ? .low : .none
        }
        
        disposables += hasMenstruation.producer.startWithValues { hasMenstruation in
            self.menstruationLevel.value = hasMenstruation ? .low : .none
        }
    }

    public func apply(_ date: Date) {
        self.date = date
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM YYYY"
        _title.value = formatter.string(from: date)
        disposables += dayInfoRepository.dayInfo(for: date).startWithResult { [unowned self] (result) in
            switch result {
            case .success(let info):
                self.dayInfo = info
                self.hasPain.value = info.hasPain
                self.hasMenstruation.value = info.hasMenstruation
                self.menstruationLevel.value = info.menstruationLevel
                self.painLevel.value = info.painLevel
            case .failure(_):
                break
            }
        }
    }

    public func save() {
        if var dayInfo = dayInfo {
            dayInfo.hasPain = hasPain.value
            dayInfo.hasMenstruation = hasMenstruation.value
            dayInfo.menstruationLevel = hasMenstruation.value ? menstruationLevel.value : .none
            dayInfo.painLevel = hasPain.value ? painLevel.value : .none
            dayInfoRepository.save(dayInfo: dayInfo).start()
        }
        onClose?(date)
    }

    deinit {
        disposables.dispose()
    }
}
