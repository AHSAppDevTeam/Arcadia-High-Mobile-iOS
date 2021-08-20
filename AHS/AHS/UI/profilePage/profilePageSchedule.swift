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
        
        let scheduleViewSize = CGSize(width: mainScrollView.frame.width - 2*profilePageViewController.horizontalPadding, height: profilePageViewController.scheduleViewHeight);
        
        let scheduleViewHorizontalPadding : CGFloat = 5;
        let scheduleViewVerticalPadding : CGFloat = scheduleViewSize.height * 0.15;
        
        let periodViewWidth = scheduleViewSize.width * 0.35;
        let separatorViewWidth = scheduleViewSize.width * 0.002;
        let timeViewWidth = scheduleViewSize.width - periodViewWidth - separatorViewWidth;
        
        let schedulePrimaryFontSize : CGFloat = scheduleViewSize.height * 0.3;
        let scheduleSecondaryFontSize : CGFloat = scheduleViewSize.height * 0.15;
        let scheduleInnerPrimaryPadding : CGFloat = scheduleViewSize.height * 0.2;
        let scheduleInnerSecondaryPadding : CGFloat = scheduleViewSize.height * 0.02;
        
        //
        
        let periodView = UIView();
        
        scheduleView.addSubview(periodView);
        
        periodView.translatesAutoresizingMaskIntoConstraints = false;
        
        periodView.leadingAnchor.constraint(equalTo: scheduleView.leadingAnchor).isActive = true;
        periodView.topAnchor.constraint(equalTo: scheduleView.topAnchor).isActive = true;
        periodView.bottomAnchor.constraint(equalTo: scheduleView.bottomAnchor).isActive = true;
        periodView.widthAnchor.constraint(equalToConstant: periodViewWidth).isActive = true;
        
        //periodView.backgroundColor = .systemRed;
        
        ///
        
        let periodNumericalLabel = UILabel();
        
        periodView.addSubview(periodNumericalLabel);
        
        periodNumericalLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        periodNumericalLabel.centerXAnchor.constraint(equalTo: periodView.centerXAnchor).isActive = true;
        periodNumericalLabel.topAnchor.constraint(equalTo: periodView.topAnchor, constant: scheduleInnerPrimaryPadding).isActive = true;
        
        periodNumericalLabel.text = "2nd";
        periodNumericalLabel.textColor = .white;
        periodNumericalLabel.font = UIFont(name: SFProDisplay_Bold, size: schedulePrimaryFontSize);
        
        //
        
        let periodLabel = UILabel();
        
        periodView.addSubview(periodLabel);
        
        periodLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        periodLabel.centerXAnchor.constraint(equalTo: periodView.centerXAnchor).isActive = true;
        periodLabel.topAnchor.constraint(equalTo: periodNumericalLabel.bottomAnchor, constant: scheduleInnerSecondaryPadding).isActive = true;
        
        periodLabel.text = "Period";
        periodLabel.textColor = .black;
        periodLabel.font = UIFont(name: SFCompactDisplay_Semibold, size: scheduleSecondaryFontSize);
        
        ///
        
        
        //
        
        let separatorView = UIView();
        
        scheduleView.addSubview(separatorView);
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false;
        
        separatorView.leadingAnchor.constraint(equalTo: periodView.trailingAnchor).isActive = true;
        separatorView.topAnchor.constraint(equalTo: scheduleView.topAnchor, constant: scheduleViewVerticalPadding).isActive = true;
        separatorView.bottomAnchor.constraint(equalTo: scheduleView.bottomAnchor, constant: -scheduleViewVerticalPadding).isActive = true;
        separatorView.widthAnchor.constraint(equalToConstant: separatorViewWidth).isActive = true;
        
        separatorView.backgroundColor = .white;
        
        //
        
        let timeView = UIView();
        
        scheduleView.addSubview(timeView);
        
        timeView.translatesAutoresizingMaskIntoConstraints = false;
        
        timeView.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor).isActive = true;
        timeView.topAnchor.constraint(equalTo: scheduleView.topAnchor).isActive = true;
        timeView.bottomAnchor.constraint(equalTo: scheduleView.bottomAnchor).isActive = true;
        timeView.trailingAnchor.constraint(equalTo: scheduleView.trailingAnchor).isActive = true;
        timeView.widthAnchor.constraint(equalToConstant: timeViewWidth).isActive = true;
        
        //timeView.backgroundColor = .systemGreen;
        
        let timeViewInnerHorizontalPadding : CGFloat = timeViewWidth / 6;
        
        ///
        
        let timeValueLabel = UILabel();
        
        timeView.addSubview(timeValueLabel);
        
        timeValueLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        // constraints are set up after timeLabel
        
        timeValueLabel.text = "30 minutes";
        timeValueLabel.textColor = .white;
        timeValueLabel.font = UIFont(name: SFProDisplay_Bold, size: schedulePrimaryFontSize);
        
        //
        
        let timeLabel = UILabel();
        
        timeView.addSubview(timeLabel);
        
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
        
        //
        
    }

}

