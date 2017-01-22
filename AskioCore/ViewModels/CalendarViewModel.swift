//
//  CalendarViewModel.swift
//  AskioCore
//
//  Created by Eliasz Sawicki on 09/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import ReactiveSwift

public protocol CalendarViewModel {
    var title: Property<String> {get}

    func openSettings()
    func showInfo(for date: Date)
    func dayInfo(for date: Date) -> SignalProducer<DayInfo, DayInfoRepositoryError>
    func dayInfo(for date: Date) -> DayInfo?
}

public class CalendarDefaultViewModel: CalendarViewModel {
    
    private var _title = MutableProperty("Kalendarz")
    public var title: Property<String>
    public var onDateSelected: ((Date)->())?
    public var onOpenSettings: (()->())?
    private var dayInfoRepository: DayInfoRepository
    
    public init(dayInfoRepository: DayInfoRepository) {
        self.dayInfoRepository = dayInfoRepository
        title = Property(_title)
    }
    
    public func showInfo(for date: Date) {
        onDateSelected?(date)
    }
    
    public func dayInfo(for date: Date) -> SignalProducer<DayInfo, DayInfoRepositoryError> {
        return dayInfoRepository.dayInfo(for: date)
    }
    
    public func dayInfo(for date: Date) -> DayInfo? {
        return dayInfoRepository.dayInfo(for: date)
    }
    
    public func openSettings() {
        onOpenSettings?()
    }
    
}
