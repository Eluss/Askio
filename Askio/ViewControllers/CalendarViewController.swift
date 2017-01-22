//
//  CalendarViewController.swift
//  Askio
//
//  Created by Eliasz Sawicki on 09/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import Foundation
import UIKit
import AskioCore
import SnapKit
import ReactiveSwift
import JTAppleCalendar

class CalendarViewController: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {

    private let viewModel: CalendarViewModel
    
    private var calendarView: JTAppleCalendarView!
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        title = viewModel.title.value
        navigationController?.navigationBar.isTranslucent = false
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViewController()
        addViewsToSuperview()
        applyConstraints()
        
        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: false, animateScroll: false,
                preferredScrollPosition: nil, completionHandler: nil)
    }
    
    func openSettings() {
        viewModel.openSettings()
    }
    
    private func setupViewController() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Opcje", style: .done, target: self, action: #selector(openSettings))
        calendarView = createCalendarView()
    }
    
    func reload(_ date: Date) {
        calendarView.reloadData()
    }
    
    private func createCalendarView() -> JTAppleCalendarView {
        let calendar = JTAppleCalendarView()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.cellInset = CGPoint(x: 2, y: 2)
        calendar.scrollingMode = .stopAtEachCalendarFrameWidth
        calendar.registerCellViewClass(type: CalendarCellView.self)
        calendar.registerHeaderView(classTypeNames: [CalendarHeaderView.self])
        return calendar
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.text = viewModel.title.value        
        return label
    }
    
    private func addViewsToSuperview() {
        view.addSubview(calendarView)
    }
    
    private func applyConstraints() {
        
        calendarView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view)
            make.height.equalTo(400)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let cell = cell as! CalendarCellView
        let currentMonth = cellState.dateBelongsTo == .thisMonth
        let dayInfo: DayInfo = viewModel.dayInfo(for: date) ?? DayInfo(date: Date())
        cell.viewModel.apply(date, belongsToCurrentMonth: currentMonth, dayInfo: dayInfo)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        // move to ViewModel
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let start = "01.01.2016"
        let end = "31.12.2017"
        let startDate = formatter.date(from: start)!
        let endDate = formatter.date(from: end)!
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar:  Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfRow,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        let header = header as! CalendarHeaderView
        header.viewModel.apply(range.start)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: 200, height: 40)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        viewModel.showInfo(for: date)
    }
}
