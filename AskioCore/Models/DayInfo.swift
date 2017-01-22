//
//  DayInfo.swift
//  Askio
//
//  Created by Eliasz Sawicki on 19/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

public struct DayInfo {
    
    var date: Date
    var hasPain: Bool
    var hasMenstruation: Bool
    var painLevel: LevelScale
    var menstruationLevel: LevelScale
    
    init(date: Date, hasPain: Bool, hasMenstruation: Bool, painLevel: LevelScale, menstruationLevel: LevelScale) {
        self.date = date
        self.hasPain = hasPain
        self.hasMenstruation = hasMenstruation
        self.painLevel = painLevel
        self.menstruationLevel = menstruationLevel
    }
    
    public init(date: Date) {
        self.date = date
        hasPain = false
        hasMenstruation = false
        painLevel = .none
        menstruationLevel = .none
    }
    
}

class DayInfoRealm: Object {
    public dynamic var hasPain: Bool = false
    public dynamic var hasMenstruation: Bool = false
    
    public dynamic var date: Date?
    private dynamic var rawPainLevel = -1
    private dynamic var rawMenstruationLevel = -1
    
    public var painLevel: LevelScale {
        get {
            return LevelScale(rawValue: rawPainLevel) ?? .none
        }
        set {
            rawPainLevel = newValue.rawValue
        }
    }
    public var menstruationLevel: LevelScale {
        get {
            return LevelScale(rawValue: rawMenstruationLevel) ?? .none
        }
        set {
            rawMenstruationLevel = newValue.rawValue
        }
    }
    
    public required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    public required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    
    public init(date: Date, hasPain: Bool, hasMenstruation: Bool) {
        super.init()
        self.date = date
        self.hasPain = hasPain
        self.hasMenstruation = hasMenstruation
    }
    
    public init(dayInfo: DayInfo) {
        super.init()
        self.date = dayInfo.date
        self.hasPain = dayInfo.hasPain
        self.hasMenstruation = dayInfo.hasMenstruation
        self.painLevel = dayInfo.painLevel
        self.menstruationLevel = dayInfo.menstruationLevel
    }
    
    public func update(with dayInfo: DayInfo) {
        date = dayInfo.date
        hasPain = dayInfo.hasPain
        hasMenstruation = dayInfo.hasMenstruation
        painLevel = dayInfo.painLevel
        menstruationLevel = dayInfo.menstruationLevel
        
    }
    
    public func dayInfo() -> DayInfo? {
        guard let date = date else {
            return nil
        }
        let info = DayInfo(date: date, hasPain: hasPain, hasMenstruation: hasMenstruation, painLevel: painLevel, menstruationLevel: menstruationLevel)
        return info
    }
    
    public required init() {
        super.init()
    }
    
    public override init(value: Any) {
        super.init(value: value)
    }
    
    
    public override class func ignoredProperties() -> [String] {
        return ["painLevel", "menstruationLevel"]
    }

}
