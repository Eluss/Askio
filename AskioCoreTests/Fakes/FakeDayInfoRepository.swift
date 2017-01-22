//
//  FakeDayInfoRepository.swift
//  Askio
//
//  Created by Eliasz Sawicki on 22/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import AskioCore
import ReactiveSwift

class FakeDayInfoRepository: DayInfoRepository {
    
    func dayInfo(for date: Date) -> SignalProducer<DayInfo, DayInfoRepositoryError> {
        return SignalProducer { observer, _ in
            
        }
    }
    
    func save(dayInfo: DayInfo) -> SignalProducer<DayInfo, DayInfoRepositoryError> {
        return SignalProducer { observer, _ in
            
        }
    }
    
    func dayInfo(for date: Date) -> DayInfo? {
        return nil
    }
    
    func reloadAll() {
        
    }
    
}
