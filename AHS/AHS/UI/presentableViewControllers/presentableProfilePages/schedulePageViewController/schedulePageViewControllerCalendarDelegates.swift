//
//  schedulePageViewControllerCalendarDelegates.swift
//  AHS
//
//  Created by Richard Wei on 10/8/21.
//

import Foundation
import UIKit
import JTAppleCalendar

extension schedulePageViewController : JTACMonthViewDataSource, JTACMonthViewDelegate{
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        let currentDate = Date();
        
        //let startDate = formatter.date(from: "01 2021")!;
        //let endDate = Date();
        
        return ConfigurationParameters(startDate: currentDate, endDate: currentDate);
    }
    
    //
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: ScheduleCalendarDayCell.identifier, for: indexPath) as! ScheduleCalendarDayCell;
        setupCalendarDayCell(cell, cellState, date);
        return cell;
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let scheduleCell = cell as! ScheduleCalendarDayCell;
        setupCalendarDayCell(scheduleCell, cellState, date);
    }
    
    internal func setupCalendarDayCell(_ cell: ScheduleCalendarDayCell, _ cellState: CellState, _ date: Date){
        cell.updateWithDate(date, cellState);
    }
    
    //
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        
        guard let scheduleCell = cell as? ScheduleCalendarDayCell else{
            return;
        }
        
        scheduleCell.updateSelectedState(cellState);
        
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        
        guard let scheduleCell = cell as? ScheduleCalendarDayCell else{
            return;
        }
        
        scheduleCell.updateSelectedState(cellState);
        
    }
    
}
