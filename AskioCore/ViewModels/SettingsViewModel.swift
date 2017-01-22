//
//  SettingsViewModel.swift
//  Askio
//
//  Created by Eliasz Sawicki on 22/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import ReactiveSwift

public protocol SettingsViewModel {
    var screenTitle: String {get}
    var timerTitle: String {get}
    var pickedDate: MutableProperty<Date> {get}
    var isNotificationOn: MutableProperty<Bool> {get}
    var toggleNotification: Action<(Bool, Date?), Void, NotificationRepositoryError>! {get}
}

public class SettingsDefaultViewModel: SettingsViewModel {
    
    public var screenTitle: String = "Ustawienia"
    public var timerTitle: String = "Ustaw godzinę przypomnienia:"
    public var pickedDate = MutableProperty(Date())
    public var isNotificationOn = MutableProperty(false)
    private var disposables = CompositeDisposable()
    
    private var notificationRepository: NotificationRepository
    public var toggleNotification: Action<(Bool, Date?), Void, NotificationRepositoryError>!
    
    public init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
        
        toggleNotification = Action {(isNotificationOn, notificationDate) -> SignalProducer<Void, NotificationRepositoryError> in
            return SignalProducer {[weak self] observer, _ in
                guard let strongSelf = self else {
                    observer.sendInterrupted()
                    return
                }
                if let notificationDate = notificationDate, isNotificationOn {
                    strongSelf.notificationRepository.scheduleNotification(for: notificationDate).start(observer)
                } else {
                    strongSelf.notificationRepository.deleteNotification().start(observer)
                }
            }
        }
        reload()
    }
    
    private func reload() {
        disposables += notificationRepository.notification().startWithResult {[unowned self] (result) in
            switch result {
            case .success(let date) where date != nil:
                self.pickedDate.value = date!
                self.isNotificationOn.value = true
            default:
                self.isNotificationOn.value = false
                break
            }
        }
    }
    
    deinit {
        disposables.dispose()
    }
    
}
