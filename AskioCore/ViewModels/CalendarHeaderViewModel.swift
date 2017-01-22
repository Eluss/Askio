//
//  CalendarHeaderViewModel.swift
//  Askio
//
//  Created by Eliasz Sawicki on 19/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import ReactiveSwift

public protocol CalendarHeaderViewModel {
    var title: Property<String> {get}
    
    func apply(_ date: Date)
}

public class CalendarHeaderDefaultViewModel: CalendarHeaderViewModel {
    
    public var title: Property<String>
    private let _title = MutableProperty("")
    
    public init() {
        title = Property(_title)
    }
    
    public func apply(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        _title.value = formatter.string(from: date)
    }
    
    
}
