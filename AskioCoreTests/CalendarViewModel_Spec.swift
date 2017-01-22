//
//  CalendarViewModel_Spec.swift
//  Askio
//
//  Created by Eliasz Sawicki on 09/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import AskioCore

class CalendarViewModel_Spec: QuickSpec {

    override func spec() {
        
        describe("CalendarViewModel") {
            
            var didOpenSettings: Bool!
            var didSelectDate: Date?
            var dayInfoRepository: DayInfoRepository!
            var viewModel: CalendarDefaultViewModel!
            
            beforeEach {
                didOpenSettings = false
                dayInfoRepository = FakeDayInfoRepository()
                viewModel = CalendarDefaultViewModel(dayInfoRepository: dayInfoRepository)
                viewModel.onOpenSettings = {
                    didOpenSettings = true
                }
                
                viewModel.onDateSelected = { date in
                    didSelectDate = date
                }
            }
            
            it("Title equals test") {
                expect(viewModel.title.value).to(equal("Kalendarz"))
            }
            
            it("Opens settings") {
                viewModel.openSettings()
                expect(didOpenSettings).to(beTrue())
            }
            
            it("Shows day info") {
                let date = Date()
                viewModel.showInfo(for: date)
                expect(didSelectDate).to(equal(date))
            }
            
        }
        
    }
    
}
