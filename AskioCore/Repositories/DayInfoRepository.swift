//
//  DayInfoRepository.swift
//  Askio
//
//  Created by Eliasz Sawicki on 19/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import ReactiveSwift
import RealmSwift

public enum DayInfoRepositoryError: Error {
    case failed
}

public protocol DayInfoRepository {
    func dayInfo(for date: Date) -> SignalProducer<DayInfo, DayInfoRepositoryError>
    func save(dayInfo: DayInfo) -> SignalProducer<DayInfo, DayInfoRepositoryError>
    func dayInfo(for date: Date) -> DayInfo?
    func reloadAll()
}

public class DayInfoRealmRepository: DayInfoRepository {
    
    let realm = try! Realm()
    
    var allInfo = [DayInfo]()
    
    public init() {
        
    }
    
    public func reloadAll() {
        let all = realm.objects(DayInfoRealm.self)
        let infos = all.map { (realm) -> DayInfo? in
            return realm.dayInfo()
        }
        allInfo = infos.flatMap { $0 }
    }
    
    public func dayInfo(for date: Date) -> DayInfo? {
        let infosWithDate = allInfo.filter { (info) -> Bool in
            return info.date == date
        }
        return infosWithDate.first
    }
    
    
    public func dayInfo(for date: Date) -> SignalProducer<DayInfo, DayInfoRepositoryError> {
        return SignalProducer {[weak self] observer, _ in
            guard let strongSelf = self else {
                observer.sendInterrupted()
                return
            }
            let predicate = NSPredicate(format: "date = %@", date as CVarArg)
            let all = strongSelf.realm.objects(DayInfoRealm.self).filter(predicate)
            let info = all.first?.dayInfo() ?? DayInfo(date: date)
            print("Found for date: \(date) \(info.painLevel) \(info.menstruationLevel)")
            observer.send(value: info)
        }
    }
    
    public func save(dayInfo: DayInfo) -> SignalProducer<DayInfo, DayInfoRepositoryError> {
        return SignalProducer {[weak self] observer, _ in
            guard let strongSelf = self else {
                observer.sendInterrupted()
                return
            }
            let predicate = NSPredicate(format: "date = %@", dayInfo.date as CVarArg)
            if let result = strongSelf.realm.objects(DayInfoRealm.self).filter(predicate).first as DayInfoRealm? {
                try! strongSelf.realm.write {
                    result.update(with: dayInfo)
                }
            } else {
                try! strongSelf.realm.write {
                    let dayInfoRealm = DayInfoRealm(dayInfo: dayInfo)
                    strongSelf.realm.add(dayInfoRealm)
                }
            }
        }
    }
    
}
