//
//  CalendarCellViewModel.swift
//  Askio
//
//  Created by Eliasz Sawicki on 19/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import ReactiveSwift
public protocol CalendarCellViewModel {
    var belongsToCurrentMonth: Property<Bool> {get}
    var dayText: Property<String> {get}
    var painLevel: Property<LevelScale> {get}
    var menstruationLevel: Property<LevelScale> {get}
    func apply(_ date: Date, belongsToCurrentMonth: Bool, dayInfo: DayInfo)
}

public class CalendarCellDefaultViewModel: CalendarCellViewModel {
    
    public var dayText: Property<String>
    private var _dayText = MutableProperty<String>("")
    
    public var painLevel: Property<LevelScale>
    private var _painLevel = MutableProperty<LevelScale>(.none)
    
    public var menstruationLevel: Property<LevelScale>
    private var _menstruationLevel = MutableProperty<LevelScale>(.none)
    
    public var belongsToCurrentMonth: Property<Bool>
    private var _belongsToCurrentMonth = MutableProperty(false)
    private var dayInfo: DayInfo?
    
    public init() {
        belongsToCurrentMonth = Property(_belongsToCurrentMonth)
        dayText = Property(_dayText)
        painLevel = Property(_painLevel)
        menstruationLevel = Property(_menstruationLevel)
    }
    
    public func apply(_ date: Date, belongsToCurrentMonth: Bool, dayInfo: DayInfo) {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        _dayText.value = formatter.string(from: date)
        _belongsToCurrentMonth.value = belongsToCurrentMonth
        _painLevel.value = dayInfo.painLevel
        _menstruationLevel.value = dayInfo.menstruationLevel
    }
}
