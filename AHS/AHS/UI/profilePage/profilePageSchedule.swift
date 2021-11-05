//
//  profilePageSchedule.swift
//  AHS
//
//  Created by Richard Wei on 8/15/21.
//

import Foundation
import UIKit

extension profilePageViewController{
    
    internal func renderSchedule(){
        
        scheduleView.backgroundColor = UIColor.init(hex: "#70afb4");
        scheduleView.layer.cornerRadius = 10;
        scheduleView.clipsToBounds = true;
        
        //
        
        loadSchedule();
        
        //
        
    }
    
    internal func loadSchedule(){
        
        dataManager.getTodaySchedule(completion: { (scheduledata) in
            
            for subview in self.scheduleView.subviews{
                if subview.tag == 1{
                    subview.removeFromSuperview();
                }
            }
            
            self.renderInnerSchedule(scheduledata);
            
        });
        
    }
    
    private func renderInnerSchedule(_ scheduledata: scheduleCalendarData){
        
        //print("current time - \(timeManager.regular.getMinSinceMidnightFromDate())")
        
        var periodID : String = ""; // if empty, no period (out of school time)
        var nextTimestamp : Int = 0;
        
        if (scheduledata.timestamps.count > 0){
            for i in 1..<scheduledata.timestamps.count{
                
                guard i-1 < scheduledata.periodIDs.count else{
                    continue;
                }
                
                let currentTime = timeManager.regular.getMinSinceMidnightFromDate();
                
                if (currentTime >= scheduledata.timestamps[i-1] && currentTime <= scheduledata.timestamps[i]){
                    periodID = scheduledata.periodIDs[i-1];
                    nextTimestamp = scheduledata.timestamps[i];
                    break;
                }
                
            }
        }
        
        let scheduleViewSize = CGSize(width: mainScrollView.frame.width - 2*profilePageViewController.horizontalPadding, height: profilePageViewController.scheduleViewHeightRatio * (profilePageViewController.contentTableViewRowHeightRatio * AppUtility.getCurrentScreenSize().width));
        let schedulePrimaryFontSize : CGFloat = scheduleViewSize.height * 0.3;
        let scheduleSecondaryFontSize : CGFloat = scheduleViewSize.height * 0.15;
        let scheduleInnerPrimaryPadding : CGFloat = scheduleViewSize.height * 0.2;
        let scheduleInnerSecondaryPadding : CGFloat = scheduleViewSize.height * 0.02;
        
        if (!periodID.isEmpty){
            
            //let scheduleViewHorizontalPadding : CGFloat = 5;
            let scheduleViewVerticalPadding : CGFloat = scheduleViewSize.height * 0.15;
            
            let periodViewWidth = scheduleViewSize.width * 0.35;
            let separatorViewWidth = scheduleViewSize.width * 0.002;
            let timeViewWidth = scheduleViewSize.width - periodViewWidth - separatorViewWidth;
            
            
            //
            
            let periodView = UIView();
            
            scheduleView.addSubview(periodView);
            
            periodView.tag = 1;
            periodView.translatesAutoresizingMaskIntoConstraints = false;
            
            periodView.leadingAnchor.constraint(equalTo: scheduleView.leadingAnchor).isActive = true;
            periodView.topAnchor.constraint(equalTo: scheduleView.topAnchor).isActive = true;
            periodView.bottomAnchor.constraint(equalTo: scheduleView.bottomAnchor).isActive = true;
            periodView.widthAnchor.constraint(equalToConstant: periodViewWidth).isActive = true;
            
            //periodView.backgroundColor = .systemRed;
            
            ///
            
            let isValidPeriod = Int(periodID) != nil;
            
            ///
            
            let periodNumber = Int(periodID) ?? 0;
            
            let periodNumericalLabel = UILabel();
            
            periodView.addSubview(periodNumericalLabel);
            
            periodNumericalLabel.tag = 1;
            periodNumericalLabel.translatesAutoresizingMaskIntoConstraints = false;
            
            periodNumericalLabel.centerXAnchor.constraint(equalTo: periodView.centerXAnchor).isActive = true;
            periodNumericalLabel.topAnchor.constraint(equalTo: periodView.topAnchor, constant: scheduleInnerPrimaryPadding).isActive = true;
                        
            periodNumericalLabel.text = isValidPeriod ? "\(periodNumber)\(timeManager.getNumberSuffix(periodNumber-1))" : periodID.capitalizingFirstLetter();
            periodNumericalLabel.textColor = .white;
            periodNumericalLabel.font = UIFont(name: SFProDisplay_Bold, size: schedulePrimaryFontSize);
            
            //
            
            let periodLabel = UILabel();
            
            periodView.addSubview(periodLabel);
            
            periodLabel.tag = 1;
            periodLabel.translatesAutoresizingMaskIntoConstraints = false;
            
            periodLabel.centerXAnchor.constraint(equalTo: periodView.centerXAnchor).isActive = true;
            periodLabel.topAnchor.constraint(equalTo: periodNumericalLabel.bottomAnchor, constant: scheduleInnerSecondaryPadding).isActive = true;
            
            periodLabel.text = "Period";
            periodLabel.textColor = .black;
            periodLabel.font = UIFont(name: SFCompactDisplay_Semibold, size: scheduleSecondaryFontSize);
            periodLabel.isHidden = !isValidPeriod;
            
            ///
            
            
            //
            
            let separatorView = UIView();
            
            scheduleView.addSubview(separatorView);
            
            separatorView.tag = 1;
            separatorView.translatesAutoresizingMaskIntoConstraints = false;
            
            separatorView.leadingAnchor.constraint(equalTo: periodView.trailingAnchor).isActive = true;
            separatorView.topAnchor.constraint(equalTo: scheduleView.topAnchor, constant: scheduleViewVerticalPadding).isActive = true;
            separatorView.bottomAnchor.constraint(equalTo: scheduleView.bottomAnchor, constant: -scheduleViewVerticalPadding).isActive = true;
            separatorView.widthAnchor.constraint(equalToConstant: separatorViewWidth).isActive = true;
            
            separatorView.backgroundColor = .white;
            
            //
            
            let timeView = UIView();
            
            scheduleView.addSubview(timeView);
            
            timeView.tag = 1;
            timeView.translatesAutoresizingMaskIntoConstraints = false;
            
            timeView.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor).isActive = true;
            timeView.topAnchor.constraint(equalTo: scheduleView.topAnchor).isActive = true;
            timeView.bottomAnchor.constraint(equalTo: scheduleView.bottomAnchor).isActive = true;
            timeView.trailingAnchor.constraint(equalTo: scheduleView.trailingAnchor).isActive = true;
            timeView.widthAnchor.constraint(equalToConstant: timeViewWidth).isActive = true;
            
            //timeView.backgroundColor = .systemGreen;
            
            let timeViewInnerHorizontalPadding : CGFloat = timeViewWidth / 6;
            
            ///
            
            let timeDifference = nextTimestamp - timeManager.regular.getMinSinceMidnightFromDate();
            
            let timeValueLabel = UILabel();
            
            timeView.addSubview(timeValueLabel);
            
            timeValueLabel.tag = 1;
            timeValueLabel.translatesAutoresizingMaskIntoConstraints = false;
            
            // constraints are set up after timeLabel
            let timeValue = max(timeDifference, -1);
            
            timeValueLabel.text = "\(timeValue) minute\(timeValue > 1 ? "s" : "")";
            timeValueLabel.textColor = .white;
            timeValueLabel.font = UIFont(name: SFProDisplay_Bold, size: schedulePrimaryFontSize);
            
            //
            
            let timeLabel = UILabel();
            
            timeView.addSubview(timeLabel);
            
            timeLabel.tag = 1;
            timeLabel.translatesAutoresizingMaskIntoConstraints = false;
            
            timeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: timeView.leadingAnchor, constant: timeViewInnerHorizontalPadding).isActive = true;
            timeLabel.topAnchor.constraint(equalTo: timeValueLabel.bottomAnchor, constant: scheduleInnerSecondaryPadding).isActive = true;
            
            timeLabel.text = "Time Remaining";
            timeLabel.textColor = .black;
            timeLabel.font = UIFont(name: SFCompactDisplay_Semibold, size: scheduleSecondaryFontSize);
            
            //
            
            timeValueLabel.centerXAnchor.constraint(equalTo: timeLabel.centerXAnchor).isActive = true;
            timeValueLabel.topAnchor.constraint(equalTo: timeView.topAnchor, constant: scheduleInnerPrimaryPadding).isActive = true;
            timeValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: timeView.leadingAnchor, constant: timeViewInnerHorizontalPadding * 0.6).isActive = true;
            
            //
            
            let chevronImageView = UIImageView();
            
            timeView.addSubview(chevronImageView);
            
            chevronImageView.tag = 1;
            chevronImageView.translatesAutoresizingMaskIntoConstraints = false;
            
            chevronImageView.trailingAnchor.constraint(equalTo: timeView.trailingAnchor, constant: -(timeViewInnerHorizontalPadding / 2)).isActive = true;
            chevronImageView.topAnchor.constraint(equalTo: timeView.topAnchor, constant: scheduleInnerPrimaryPadding).isActive = true;
            chevronImageView.bottomAnchor.constraint(equalTo: timeView.bottomAnchor, constant: -scheduleInnerPrimaryPadding).isActive = true;
            chevronImageView.leadingAnchor.constraint(greaterThanOrEqualTo: timeValueLabel.trailingAnchor, constant: timeViewInnerHorizontalPadding / 2).isActive = true;
            chevronImageView.leadingAnchor.constraint(greaterThanOrEqualTo: timeLabel.trailingAnchor, constant: timeViewInnerHorizontalPadding / 2).isActive = true;
            
            chevronImageView.contentMode = .scaleAspectFit;
            chevronImageView.image = UIImage(systemName: "chevron.right");
            chevronImageView.tintColor = .white;
            
            ///
        }
        else{
            
            let scheduleLabel = UILabel();
            
            scheduleView.addSubview(scheduleLabel);
            
            scheduleLabel.tag = 1;
            scheduleLabel.translatesAutoresizingMaskIntoConstraints = false;
            
            scheduleLabel.centerXAnchor.constraint(equalTo: scheduleView.centerXAnchor).isActive = true;
            scheduleLabel.centerYAnchor.constraint(equalTo: scheduleView.centerYAnchor).isActive = true;
            
            scheduleLabel.text = "\(scheduledata.title)" + "\n" + "(Out of school)";
            scheduleLabel.textColor = InverseBackgroundColor;
            scheduleLabel.font = UIFont(name: SFProDisplay_Semibold, size: scheduleView.frame.width * 0.06);
            scheduleLabel.numberOfLines = 0;
            scheduleLabel.textAlignment = .center;
            
            //
            
            let chevronImageView = UIImageView();
            
            scheduleView.addSubview(chevronImageView);
            
            chevronImageView.tag = 1;
            chevronImageView.translatesAutoresizingMaskIntoConstraints = false;
            
            chevronImageView.trailingAnchor.constraint(equalTo: scheduleView.trailingAnchor, constant: -scheduleInnerPrimaryPadding).isActive = true;
            chevronImageView.topAnchor.constraint(equalTo: scheduleView.topAnchor, constant: scheduleInnerPrimaryPadding).isActive = true;
            chevronImageView.bottomAnchor.constraint(equalTo: scheduleView.bottomAnchor, constant: -scheduleInnerPrimaryPadding).isActive = true;
            chevronImageView.leadingAnchor.constraint(greaterThanOrEqualTo: scheduleLabel.trailingAnchor, constant: (scheduleInnerPrimaryPadding / 2)).isActive = true;
            
            chevronImageView.contentMode = .scaleAspectFit;
            chevronImageView.image = UIImage(systemName: "chevron.right");
            chevronImageView.tintColor = .white;
            //chevronImageView.backgroundColor = .systemRed;
            
        }
        
    }
    
}

