//
//  LocalNotificationRepository.swift
//  Askio
//
//  Created by Eliasz Sawicki on 22/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import UIKit
import AskioCore
import ReactiveSwift

public class LocalNotificationRepository: NotificationRepository {
    
    public init() {
        
    }
    
    
    public func scheduleNotification(for date: Date) -> SignalProducer<Void, NotificationRepositoryError> {
        return SignalProducer {[weak self] observer, _ in
            guard let strongSelf = self else {
                observer.sendInterrupted()
                return
            }
            strongSelf.deleteNotification().startWithResult({ (result) in
                let notification = UILocalNotification()
                
                notification.fireDate = date
                notification.repeatInterval = .day
                notification.timeZone = Calendar.current.timeZone
                notification.alertBody = "Jak się dzisiaj czułaś?"
                UIApplication.shared.scheduleLocalNotification(notification)
                observer.send(value: ())
                observer.sendCompleted()
            })
        }
    }
    
    public func deleteNotification() -> SignalProducer<Void, NotificationRepositoryError> {
        return SignalProducer { observer, _ in
            if let notification = UIApplication.shared.scheduledLocalNotifications?.first {
                UIApplication.shared.cancelLocalNotification(notification)
                observer.send(value: ())
            } else {
                observer.send(error: .noNotificationToDelete)
            }
            observer.sendCompleted()
        }
    }
    
    public func notification() -> SignalProducer<Date?, NotificationRepositoryError> {
        return SignalProducer { observer, _ in
            let notification = UIApplication.shared.scheduledLocalNotifications?.first
            observer.send(value: notification?.fireDate)
            observer.sendCompleted()
        }
    }
    
}
