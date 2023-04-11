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
    
    internal let minuteToHeightRatio : CGFloat = 3.5;
    
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
        
        //
                
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
        nextY += dayOfWeekLabel.frame.height + (verticalPadding / 8);
        
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
        nextY += scheduleTypeLabel.frame.height + 1.5 * verticalPadding;
        
        //
        
        if (scheduledata.timestamps.count > 1){
            
            let scheduleTotalTime : CGFloat = CGFloat((scheduledata.timestamps.last ?? 0) - (scheduledata.timestamps.first ?? 0));
            
            guard scheduleTotalTime > 0 else{
                print("invalid schedule total time");
                return;
            }
            
            let timestampViewHeight : CGFloat = scheduleTotalTime * minuteToHeightRatio;
            let timestampViewWidth : CGFloat = mainScrollView.frame.width / 5;
            let timestampViewFrame = CGRect(x: horizontalPadding, y: nextY, width: timestampViewWidth, height: timestampViewHeight);
            let timestampView = UIView(frame: timestampViewFrame);
            
            renderScheduleTimestamp(timestampView, date, scheduledata);
            
            timestampView.tag = 1;
            
            mainScrollView.addSubview(timestampView);
            // no nextY set because of schedule rendering
            
            //
            
            
            /*for i in 1..<scheduledata.timestamps.count{
                
                let periodTime : Int = scheduledata.timestamps[i] - scheduledata.timestamps[i-1];
                
                let periodViewHeight = CGFloat(periodTime) * minuteToHeightRatio;
                let periodViewFrame = CGRect(x: timestampView.frame.width + 2*horizontalPadding, y: nextY, width: mainScrollView.frame.width - (timestampView.frame.width + 3*horizontalPadding), height: periodViewHeight);
                let periodView = UIView(frame: periodViewFrame);
                
                periodView.layer.cornerRadius = 5;
                periodView.clipsToBounds = true;
                
                guard i - 1 < scheduledata.periodIDs.count else{
                    print("index out of bounds when rendering schedule - \(scheduledata.title)")
                    return;
                }
                
                let periodID = scheduledata.periodIDs[i-1];
                
                //
                
                let periodLabelFontSize = periodView.frame.width * 0.05;
                
                let periodLabel = UILabel();
                periodView.addSubview(periodLabel);
                
                periodLabel.translatesAutoresizingMaskIntoConstraints = false;
                
                periodLabel.centerXAnchor.constraint(equalTo: periodView.centerXAnchor).isActive = true;
                periodLabel.centerYAnchor.constraint(equalTo: periodView.centerYAnchor).isActive = true;
                
                periodLabel.textColor = InverseBackgroundColor;
                periodLabel.font = UIFont(name: SFProDisplay_Bold, size: periodLabelFontSize);
                
                if let periodInt = Int(periodID){
                    //print("period - \(periodInt)")
                    periodView.backgroundColor = scheduledata.color;
                    
                    //
                    
                    periodLabel.text = "Period \(periodInt)";
                    
                }
                else{
                    periodView.backgroundColor = BackgroundColor;
                    
                    if (periodID != "passing" && CGFloat(periodTime) * self.minuteToHeightRatio > periodLabelFontSize){
                        
                        periodLabel.text = periodID.capitalizingFirstLetter();
                        
                    }
                    
                }
                
                //
                
                periodView.tag = 1;
                
                mainScrollView.addSubview(periodView);
                nextY += periodView.frame.height;
                
            }*/
            
            
            //
        }
        else{
            
            let noScheduleLabelWidth = mainScrollView.frame.width;
            let noScheduleLabelFrame = CGRect(x: 0, y: nextY, width: noScheduleLabelWidth, height: noScheduleLabelWidth * 0.07);
            let noScheduleLabel = UILabel(frame: noScheduleLabelFrame);
            
            noScheduleLabel.text = "No Schedule";
            noScheduleLabel.textColor = InverseBackgroundColor;
            noScheduleLabel.textAlignment = .center;
            noScheduleLabel.font = UIFont(name: SFProDisplay_Semibold, size: noScheduleLabelFrame.height * 0.7);
            
            noScheduleLabel.tag = 1;
            
            mainScrollView.addSubview(noScheduleLabel);
            nextY += noScheduleLabel.frame.height
        }
        
        mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: nextY);
        
    }
    
    private func renderScheduleTimestamp(_ timestampView: UIView, _ date: Date, _ scheduledata: scheduleCalendarData){
        
        //timestampView.backgroundColor = .systemRed;
        
        let labelWidth = timestampView.frame.width;
        let labelHeight = labelWidth * 0.24;
        let labelFont = UIFont(name: SFProDisplay_Semibold, size: labelHeight * 0.7);
        
        //
        
        for timestamp in scheduledata.timestamps{
            
            let timeSinceBeginningOfDay : CGFloat = CGFloat(timestamp - scheduledata.timestamps[0]);
            
            let timestampLabelFrameY = min(timestampView.frame.height - labelHeight, max((timeSinceBeginningOfDay * self.minuteToHeightRatio) - (labelHeight / 2), 0));
            let timestampLabelFrame = CGRect(x: 0, y: timestampLabelFrameY, width: labelWidth, height: labelHeight);
            let timestampLabel = UILabel(frame: timestampLabelFrame);
            
            timestampLabel.textColor = InverseBackgroundColor;
            timestampLabel.textAlignment = .center;
            timestampLabel.font = labelFont;
            timestampLabel.text = timeManager.regular.getFormattedTimeString(timeManager.regular.getDateFromMinSinceMidnight(timestamp));
            
            timestampView.addSubview(timestampLabel);
        }
        
    }
    
}
