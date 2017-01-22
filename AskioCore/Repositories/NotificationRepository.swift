//
//  NotificationRepository.swift
//  Askio
//
//  Created by Eliasz Sawicki on 22/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import ReactiveSwift

public enum NotificationRepositoryError: Error {
    case failed
    case noNotificationToDelete
}

public protocol NotificationRepository {
    func scheduleNotification(for date: Date) -> SignalProducer<Void, NotificationRepositoryError>
    func deleteNotification() -> SignalProducer<Void, NotificationRepositoryError>
    func notification() -> SignalProducer<Date?, NotificationRepositoryError>
}

