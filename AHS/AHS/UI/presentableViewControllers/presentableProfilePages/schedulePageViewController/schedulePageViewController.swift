//
//  schedulePageViewController.swift
//  AHS
//
//  Created by Richard Wei on 8/29/21.
//

import Foundation
import UIKit
import JTAppleCalendar

class schedulePageViewController : presentableViewController{
    
    //
        
    internal let dismissButton : UIButton = UIButton();
    
    internal let mainScrollView : UIButtonScrollView = UIButtonScrollView();
    internal let refreshControl : UIRefreshControl = UIRefreshControl();
    
    internal let horizontalPadding : CGFloat = 10;
    internal let verticalPadding : CGFloat = 10;
    
    internal let monthLabel : UILabel = UILabel();
    internal let calendarView : JTACMonthView = JTACMonthView();
    
    internal var nextY : CGFloat = 0;
    internal var defaultNextY : CGFloat = 0;
    
    internal let minuteToHeightRatio : CGFloat = 3;
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.setupPanGesture();
        
        self.view.backgroundColor = BackgroundColor;
        
        //
        
        renderDismissView();
        
        //
        
        mainScrollView.frame = CGRect(x: 0, y: dismissButton.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - dismissButton.frame.maxY);
        
        mainScrollView.alwaysBounceVertical = true;
        
        self.view.addSubview(mainScrollView);
        
        //
        
        mainScrollView.addSubview(refreshControl);
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged);
        
        //
        
        renderCalendar();
        loadCalendarData();
        
        //
        
    }
    
    private func renderDismissView(){
        
        let dismissViewWidth = self.view.frame.width;
        let dismissViewFrame = CGRect(x: 0, y: AppUtility.safeAreaInset.top, width: dismissViewWidth, height: dismissViewWidth * 0.09);
        dismissButton.frame = dismissViewFrame;
        
        //
        
        let dismissButtonHorizontalPadding : CGFloat = 10;
        let dismissButtonVerticalPadding : CGFloat = 5;
        
        //
        
        let dismissImageViewSize = dismissButton.frame.height - 2*dismissButtonVerticalPadding;
        
        let dismissImageViewFrame = CGRect(x: dismissButtonHorizontalPadding, y: dismissButtonVerticalPadding, width: dismissImageViewSize, height: dismissImageViewSize);
        let dismissImageView = UIImageView(frame: dismissImageViewFrame);
        
        dismissImageView.image = UIImage(systemName: "chevron.left");
        dismissImageView.contentMode = .scaleAspectFit;
        dismissImageView.tintColor = InverseBackgroundColor;
        
        dismissButton.addSubview(dismissImageView);
        
        //
        
        let dismissTitleLabelFrame = CGRect(x: dismissImageView.frame.maxX + dismissButtonHorizontalPadding, y: dismissButtonVerticalPadding, width: dismissButton.frame.width - 2*(dismissImageView.frame.maxX + dismissButtonHorizontalPadding), height: dismissButton.frame.height - 2*dismissButtonVerticalPadding);
        let dismissTitleLabel = UILabel(frame: dismissTitleLabelFrame);
        
        dismissTitleLabel.text = "Schedule";
        dismissTitleLabel.textAlignment = .left;
        dismissTitleLabel.textColor = UIColor.init(hex: "#c74534");
        dismissTitleLabel.font = UIFont(name: SFProDisplay_Bold, size: dismissTitleLabel.frame.height * 0.9);
        
        dismissButton.addSubview(dismissTitleLabel);
        
        //
        
        //dismissButton.backgroundColor = .systemRed;
        dismissButton.addTarget(self, action: #selector(self.handleBackButton), for: .touchUpInside);
        
        //
        
        self.view.addSubview(dismissButton);
        
    }
    
    internal func loadCalendarData(){
        self.refreshControl.beginRefreshing();
        dataManager.loadCalendarData(completion: { () in
            
            self.refreshControl.endRefreshing();
            
            self.calendarView.reloadData();
            
            // retrigger selection delegate
            
            let selectedDates = self.calendarView.selectedDates;
            
            self.calendarView.deselectAllDates();
            self.calendarView.selectDates(selectedDates);
            
        });
    }
    
    //
    
    internal func renderCalendar(){
        
        nextY += verticalPadding;
        
        //
        
        let monthLabelWidth = mainScrollView.frame.width - 2*horizontalPadding;
        let monthLabelFrame = CGRect(x: horizontalPadding, y: nextY, width: monthLabelWidth, height: monthLabelWidth * 0.1);
        monthLabel.frame = monthLabelFrame;
        
        monthLabel.text = timeManager.regular.getMonthString() + " " + timeManager.regular.getYearString();
        monthLabel.textAlignment = .center;
        monthLabel.textColor = InverseBackgroundColor;
        monthLabel.font = UIFont(name: SFProDisplay_Semibold, size: monthLabel.frame.height * 0.7);
        
        mainScrollView.addSubview(monthLabel);
        nextY += monthLabel.frame.height + (verticalPadding / 2);
        
        //
        
        let calendarViewWidth = mainScrollView.frame.width;
        let calendarViewFrame = CGRect(x: 0, y: nextY, width: calendarViewWidth, height: calendarViewWidth * 0.8);
        //let calendarView = JTAppleCalendarView(frame: calendarViewFrame);
        calendarView.frame = calendarViewFrame;
        
        calendarView.calendarDelegate = self;
        calendarView.calendarDataSource = self;
        calendarView.register(ScheduleCalendarDayCell.self, forCellWithReuseIdentifier: ScheduleCalendarDayCell.identifier);
        
        calendarView.minimumInteritemSpacing = 1;
        calendarView.minimumLineSpacing = 1;
        
        calendarView.backgroundColor = BackgroundColor;
        
        calendarView.scrollDirection = .horizontal;
        calendarView.isPagingEnabled = true;
        calendarView.showsHorizontalScrollIndicator = false;
        calendarView.showsVerticalScrollIndicator = false;
        
        calendarView.selectDates([Date()]);
        calendarView.scrollToDate(Date(), animateScroll: false);
        calendarView.scrollingMode = .stopAtEachCalendarFrame;
        
        mainScrollView.addSubview(calendarView);
        nextY += calendarView.frame.height + 3*verticalPadding;
        
        //
        
        defaultNextY = nextY;
        
    }
    
    internal func renderDay(_ date: Date){
        
        for subview in mainScrollView.subviews{
            if subview.tag == 1{
                subview.removeFromSuperview();
            }
        }
        
        nextY = defaultNextY;
        
        //
        
        let dayOfWeekLabelWidth = mainScrollView.frame.width - 2*horizontalPadding;
        let dayOfWeekLabelFrame = CGRect(x: horizontalPadding, y: nextY, width: dayOfWeekLabelWidth, height: dayOfWeekLabelWidth * 0.12);
        let dayOfWeekLabel = UILabel(frame: dayOfWeekLabelFrame);
        
        dayOfWeekLabel.text = String(timeManager.getDayOfWeekString(date));
        dayOfWeekLabel.textAlignment = .left;
        dayOfWeekLabel.textColor = InverseBackgroundColor;
        dayOfWeekLabel.font = UIFont(name: SFProDisplay_Bold, size: dayOfWeekLabel.frame.height * 0.7);
        
        dayOfWeekLabel.tag = 1;
        
        mainScrollView.addSubview(dayOfWeekLabel);
        nextY += dayOfWeekLabel.frame.height + (verticalPadding / 4);
        
        //
        
        let dateLabelWidth = mainScrollView.frame.width - 2*horizontalPadding;
        let dateLabelFrame = CGRect(x: horizontalPadding, y: nextY, width: dateLabelWidth, height: dateLabelWidth * 0.10);
        let dateLabel = UILabel(frame: dateLabelFrame);
        
        dateLabel.text = "\(timeManager.regular.getMonthString(date)) \(timeManager.regular.getDateInt(date))\(timeManager.regular.getDateSuffix(date))";
        dateLabel.textAlignment = .left;
        dateLabel.textColor = InverseBackgroundColor;
        dateLabel.font = UIFont(name: SFProDisplay_Semibold, size: dateLabel.frame.height * 0.7);
        
        dateLabel.tag = 1;
        
        mainScrollView.addSubview(dateLabel);
        nextY += dateLabel.frame.height + (verticalPadding / 4);
        
        //
        
        dataManager.getDayScheduleData(date, completion: { (scheduledata) in
            
            self.renderSchedule(date, scheduledata);
            
        });
        
        //
        
        mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: nextY);
        
    }
    
    private func renderSchedule(_ date: Date, _ scheduledata: scheduleCalendarData){
        
        let scheduleTypeLabelWidth = mainScrollView.frame.width - 2*horizontalPadding;
        let scheduleTypeLabelFrame = CGRect(x: horizontalPadding, y: nextY, width: scheduleTypeLabelWidth, height: scheduleTypeLabelWidth * 0.07);
        let scheduleTypeLabel = UILabel(frame: scheduleTypeLabelFrame);
        
        scheduleTypeLabel.text = scheduledata.title;
        scheduleTypeLabel.textAlignment = .left;
        scheduleTypeLabel.textColor = scheduledata.color;
        scheduleTypeLabel.font = UIFont(name: SFProDisplay_Semibold, size: scheduleTypeLabel.frame.height * 0.7);
        
        scheduleTypeLabel.tag = 1;
        
        mainScrollView.addSubview(scheduleTypeLabel);
        nextY += scheduleTypeLabel.frame.height + verticalPadding;
        
        //
        
        if (scheduledata.timestamps.count > 1){
            for i in 1..<scheduledata.timestamps.count{
                
                let periodTime : Int = scheduledata.timestamps[i] - scheduledata.timestamps[i-1];
                
                let periodViewFrame = CGRect(x: 0, y: nextY, width: mainScrollView.frame.width, height: CGFloat(periodTime) * minuteToHeightRatio);
                let periodView = UIView(frame: periodViewFrame);
                
                if i-1 < scheduledata.periodIDs.count, let periodInt = Int(scheduledata.periodIDs[i-1]){
                    //print("period - \(periodInt)")
                    periodView.backgroundColor = scheduledata.color;
                }
                else{
                    periodView.backgroundColor = InverseBackgroundColor;
                }
                            
                periodView.tag = 1;
                
                mainScrollView.addSubview(periodView);
                nextY += periodView.frame.height;
                
            }
        }
        //
        
        mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: nextY);
        
    }
    
}
