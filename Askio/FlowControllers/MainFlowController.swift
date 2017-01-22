//
//  MainFlowController.swift
//  Askio
//
//  Created by Eliasz Sawicki on 09/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import UIKit
import AskioCore

class MainFlowController {
    
    private let rootNavigationController: UINavigationController
    
    private let calendarViewController: CalendarViewController
    private let calendarViewModel: CalendarViewModel
    
    private let dayInfoViewController: DayInfoViewController
    private let dayInfoViewModel: DayInfoViewModel
    
    init(navigationController: UINavigationController) {
        self.rootNavigationController = navigationController
        
        let dayInfoRepository = DayInfoRealmRepository()
        dayInfoRepository.reloadAll()
        let viewModel = CalendarDefaultViewModel(dayInfoRepository: dayInfoRepository)
        calendarViewModel = viewModel
        calendarViewController = CalendarViewController(viewModel: calendarViewModel)
        
        let dayInfoViewModel = DayInfoDefaultViewModel(dayInfoRepository: dayInfoRepository)
        self.dayInfoViewModel = dayInfoViewModel
        dayInfoViewController = DayInfoViewController(viewModel: dayInfoViewModel)
        
        dayInfoViewModel.onClose = { date in
            dayInfoRepository.reloadAll()
            self.calendarViewController.reload(date)
            self.rootNavigationController.popViewController(animated: true)
        }
        viewModel.onDateSelected = { date in
            self.presentDayInfo(with: date)
        }
        
        viewModel.onOpenSettings = {
            self.openSettings()
        }
    }
    
    private func openSettings() {
        let repo = LocalNotificationRepository()
        let viewModel = SettingsDefaultViewModel(notificationRepository: repo)
        let viewController = SettingsViewController(viewModel: viewModel)
        rootNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func presentDayInfo(with date: Date) {
        dayInfoViewModel.apply(date)
        rootNavigationController.pushViewController(dayInfoViewController, animated: true)
    }
    
    
    func startFlow() {
        rootNavigationController.pushViewController(calendarViewController, animated: true)
    }
}
