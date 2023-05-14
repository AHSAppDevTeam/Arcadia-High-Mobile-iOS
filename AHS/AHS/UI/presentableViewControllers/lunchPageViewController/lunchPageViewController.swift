//
//  lunchPageViewController.swift
//  AHS
//
//  Created by Mathew Xie on 4/16/23.
//

import Foundation
import UIKit

class lunchPageViewController : presentableViewController, UIScrollViewDelegate {
    internal let mainScrollView : UIButtonScrollView = UIButtonScrollView();
    internal var nextY : CGFloat = 0;
    internal let topCategoryPicker = UIView()
    internal var breakfastButton : UIButton = UIButton();
    internal var lunchButton : UIButton = UIButton();
    internal var topCategoryPickerButtons : [UIButton] = [];
    internal let horizontalPadding : CGFloat = 10;
    internal let verticalPadding : CGFloat = 5;
    internal var contentView = UIView()
    
    internal var breakfastShadow : UIView = UIView()
    internal var lunchShadow: UIView = UIView()
    
    internal var menuColor: UIColor = .cyan
    
    internal let contentViewControllers : [presentableViewController] = [breakfastViewController(), lunchViewController()];
    internal var contentViewControllerIndex : Int = 0;
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor = BackgroundColor
        nextY = 0
        let calendarView = weeklyCalendarViewController()
        calendarView.view.frame = contentView.bounds;
        contentView.addSubview(calendarView.view);
        nextY += calendarView.view.frame.width
        
        let topCategoryHeight = self.view.frame.height / 5;

        mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: topCategoryHeight);
        mainScrollView.alwaysBounceVertical = true;
        mainScrollView.delegate = self;
        self.view.addSubview(mainScrollView);

        contentView.frame = CGRect(x: 0, y: topCategoryHeight, width: self.view.frame.width, height: self.view.frame.height - topCategoryHeight)
        let vc = contentViewControllers[contentViewControllerIndex];
        
        vc.willMove(toParent: self);
        vc.view.frame = contentView.bounds;
        contentView.addSubview(vc.view);
        
        self.view.addSubview(contentView);
        setupTopCategoryButtons()
    }

    private func switchButtonShadow(_ index: Int) {
        if (index == 0) {
            breakfastShadow.backgroundColor = menuColor
            lunchShadow.backgroundColor = .clear
        }
        else {
            breakfastShadow.backgroundColor = .clear
            lunchShadow.backgroundColor = menuColor
        }
    }
    private func setupTopCategoryButtons() {
        
        topCategoryPickerButtons = [breakfastButton, lunchButton];
        //
        
        let topCategoryHeight = self.view.frame.height / 15;
        
        let outerHorizontalPadding = homePageHorizontalPadding;
        let innerHorizontalPadding = outerHorizontalPadding * (3/4);
                
        let buttonWidth = (self.view.frame.width - 2 * outerHorizontalPadding - 2 * innerHorizontalPadding) / 2;
        
        //
        let fontSize = mainScrollView.frame.width * 0.06;
        let buttonHeight = nextY + verticalPadding
        
        let breakfastButtonFrame = CGRect(x: mainScrollView.frame.width / 2 - buttonWidth, y: buttonHeight, width: buttonWidth, height: topCategoryHeight);
        breakfastButton.frame = breakfastButtonFrame
        breakfastButton.backgroundColor = .clear
        breakfastButton.setTitle("Breakfast", for: .normal)
        breakfastButton.setTitleColor(InverseBackgroundColor, for: .normal)
        breakfastButton.titleLabel?.textAlignment = .center
        breakfastButton.titleLabel?.font = UIFont(name: SFProDisplay_Bold, size: fontSize);
        breakfastButton.tag = 0
        
        breakfastButton.addTarget(self, action: #selector(self.selectCategoryButton), for: .touchUpInside)
        mainScrollView.addSubview(breakfastButton)
        
        let lunchButtonFrame = CGRect(x: mainScrollView.frame.width / 2, y: buttonHeight, width: buttonWidth, height: topCategoryHeight);
        lunchButton.frame = lunchButtonFrame
        lunchButton.backgroundColor = .clear
        lunchButton.setTitle("Lunch", for: .normal)
        lunchButton.setTitleColor(InverseBackgroundColor, for: .normal)
        lunchButton.titleLabel?.textAlignment = .center
        lunchButton.titleLabel?.font = UIFont(name: SFProDisplay_Bold, size: fontSize);
        lunchButton.tag = 1
        
        lunchButton.addTarget(self, action: #selector(self.selectCategoryButton), for: .touchUpInside)
        mainScrollView.addSubview(lunchButton)
        
        nextY += topCategoryHeight + buttonHeight
        
        let shadowHeightConstant: CGFloat = 3
        
        breakfastShadow.frame = CGRect(x: 0, y: topCategoryHeight, width: breakfastButton.frame.width, height: shadowHeightConstant)
        lunchShadow.frame = CGRect(x: 0, y: topCategoryHeight, width: lunchButton.frame.width, height: shadowHeightConstant)
        
        breakfastShadow.backgroundColor = menuColor
        
        breakfastButton.addSubview(breakfastShadow)
        lunchButton.addSubview(lunchShadow)
        nextY += shadowHeightConstant
        
        
//
//        newsButton.backgroundColor = .clear;
//        newsButton.layer.cornerRadius = newsButton.frame.height / 2;
//        newsButton.layer.borderWidth = 2;
//        newsButton.layer.borderColor = newsButtonColor.cgColor;
//
//        newsButton.setTitle("News", for: .normal);
//        newsButton.titleLabel?.font = UIFont(name: SFProDisplay_Semibold, size: newsButton.frame.height * 0.4);
//        newsButton.setTitleColor(newsButtonColor, for: .normal);
//
//        newsButton.addTarget(self, action: #selector(self.selectCategoryButton), for: .touchUpInside);
//
//        newsButton.tag = 0;
//        topCategoryPickerView.addSubview(newsButton);
//
//        //
//
//        let communityButtonFrame = CGRect(x: newsButton.frame.maxX + innerHorizontalPadding, y: 0, width: buttonWidth, height: topCategoryPickerViewHeightAnchor.constant);
//        communityButton.frame = communityButtonFrame;
//
//        communityButton.backgroundColor = .clear;
//        communityButton.layer.cornerRadius = communityButton.frame.height / 2;
//        communityButton.layer.borderWidth = 2;
//        communityButton.layer.borderColor = communityButtonColor.cgColor;
//
//        communityButton.setTitle("Community", for: .normal);
//        communityButton.titleLabel?.font = UIFont(name: SFProDisplay_Semibold, size: communityButton.frame.height * 0.4);
//        communityButton.setTitleColor(communityButtonColor, for: .normal);
//
//        communityButton.addTarget(self, action: #selector(self.selectCategoryButton), for: .touchUpInside);
//
//        communityButton.tag = 1;
//        topCategoryPickerView.addSubview(communityButton);
//
//        //
//
//        let searchButtonFrame = CGRect(x: communityButton.frame.maxX + innerHorizontalPadding, y: 0, width: searchButtonSize, height: searchButtonSize);
//        searchButton.frame = searchButtonFrame;
//
//        searchButton.backgroundColor = .clear;
//        searchButton.layer.cornerRadius = searchButton.frame.height / 2;
//        searchButton.layer.borderWidth = 2;
//        searchButton.layer.borderColor = searchButtonColor.cgColor;
//
//        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal);
//        searchButton.tintColor = searchButtonColor;
//
//        searchButton.addTarget(self, action: #selector(self.selectCategoryButton), for: .touchUpInside);
//
//        searchButton.tag = 2;
//        topCategoryPickerView.addSubview(searchButton);
//
//        //
//
//        selectCategoryButton(newsButton);
//
    }
    
    @objc func selectCategoryButton(_ sender: UIButton){
        let index = sender.tag;
        if (index != contentViewControllerIndex){
            switchButtonShadow(index)
            for view in contentView.subviews{
                view.removeFromSuperview();
            }
            
            var vc = contentViewControllers[contentViewControllerIndex];
            
            vc.willMove(toParent: nil);
            vc.view.removeFromSuperview();
            vc.removeFromParent();
                      
            vc = contentViewControllers[index];
            
            vc.willMove(toParent: self);
            vc.view.frame = contentView.bounds;
            contentView.addSubview(vc.view);
            self.addChild(vc);
            vc.didMove(toParent: self);
            
            
            contentViewControllerIndex = index;
            
        }
    }


}
