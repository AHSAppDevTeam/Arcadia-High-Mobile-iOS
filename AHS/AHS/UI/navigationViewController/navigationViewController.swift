//
//  navigationViewController.swift
//  AHS
//
//  Created by Richard Wei on 3/13/21.
//

import Foundation
import UIKit

class navigationViewController : UIViewController{
    
    // Content View
    internal var contentView : UIView = UIView();
    internal let contentViewControllers : [pageViewController] = [homePageViewController(), bulletinPageViewController(), savedPageViewController(), profilePageViewController()];
    
    // Navigation Bar View
    internal let buttonArraySize = 4;
    internal var buttonViewArray : [UIButton] = Array(repeating: UIButton(), count: 4);
    internal var navigationBarView : UIView = UIView();
    
    internal var selectedButtonIndex : Int = 0;
    
    // Top Bar View
    internal var topBarView : UIView = UIView();
    //internal var topBarHomeView : UIView = UIView();
    internal var topBarHomeImageView : UIImageView = UIImageView();
    internal var topBarTitleLabel : UITextView = UITextView();
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor = BackgroundColor;
        
        renderNavigationBar();
        renderTopBar();
        
        // setup content view
        contentView = UIView(frame: CGRect(x: 0, y: topBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - topBarView.frame.maxY - navigationBarView.frame.height));
        self.view.addSubview(contentView);
        
        selectButton(buttonViewArray[selectedButtonIndex]);
       
        // update content view with default page
        
        let vc = contentViewControllers[selectedButtonIndex];
        addChild(vc);
        vc.view.frame = contentView.bounds;
        contentView.addSubview(vc.view);
        vc.didMove(toParent: self);
        
        updateTopBar(selectedButtonIndex); // should be 0
        
    }
    
    private func renderNavigationBar(){
        
        let navigationBarViewHeight = CGFloat(1/10 * self.view.frame.height);
        let navigationBarViewFrame = CGRect(x: 0, y: self.view.frame.height - navigationBarViewHeight, width: self.view.frame.width, height: navigationBarViewHeight);
        navigationBarView = UIView(frame: navigationBarViewFrame);
        
        navigationBarView.backgroundColor = NavigationBarColor;
        
        self.view.addSubview(navigationBarView);
        
        //
        
        let buttonStackFrame = CGRect(x: 0, y: 0, width: navigationBarView.frame.width, height: navigationBarView.frame.height - AppUtility.safeAreaInset.bottom);
        let buttonStackView = UIStackView(frame: buttonStackFrame);
        
        buttonStackView.alignment = .center;
        buttonStackView.axis = .horizontal;
        buttonStackView.distribution = .fillEqually;
        
        for i in 0..<contentViewControllers.count{
            let button = UIButton();
            
            button.setImage(UIImage(systemName: contentViewControllers[i].viewControllerIconName), for: .normal);
            button.addTarget(self, action: #selector(changePage), for: .touchUpInside);
            button.imageView?.contentMode = .scaleAspectFit;
            button.contentVerticalAlignment = .fill;
            button.contentHorizontalAlignment = .fill;
            button.tintColor = NavigationButtonUnselectedColor;
            button.tag = i;
            
            button.heightAnchor.constraint(equalToConstant: buttonStackView.frame.height * 0.6).isActive = true;
            
            buttonViewArray[i] = button;
            
            buttonStackView.addArrangedSubview(button);
        }

        navigationBarView.addSubview(buttonStackView);
        
    }
    
    private func renderTopBar(){
        
        let topBarViewHeight = CGFloat(1/15 * self.view.frame.height);
        let topBarViewFrame = CGRect(x: 0, y: AppUtility.safeAreaInset.top, width: self.view.frame.width, height: topBarViewHeight);
        topBarView = UIView(frame: topBarViewFrame);
        
        //topBarView.backgroundColor = .systemTeal;
        
        self.view.addSubview(topBarView);
        
        //
        
        let notificationButtonPadding = CGFloat(10);
        let notificationButtonSize = CGFloat(topBarView.frame.height - 2*notificationButtonPadding);
        let notificationButtonFrame =  CGRect(x: topBarView.frame.width - notificationButtonPadding - notificationButtonSize, y: notificationButtonPadding, width: notificationButtonSize, height: notificationButtonSize);
        let notificationButton = UIButton(frame: notificationButtonFrame);
        
        //notificationButton.backgroundColor = .blue;
        notificationButton.setImage(UIImage(systemName: "bell.fill"), for: .normal);
        notificationButton.contentVerticalAlignment = .fill;
        notificationButton.contentHorizontalAlignment = .fill;
        notificationButton.imageView?.contentMode = .scaleAspectFit;
        notificationButton.tintColor = InverseBackgroundGrayColor;
        notificationButton.addTarget(self, action: #selector(self.openNotificationPage), for: .touchUpInside);
        
        topBarView.addSubview(notificationButton);
        
        //
        
        let titleLabelPadding = CGFloat(10);
        let titleLabelFrame = CGRect(x: titleLabelPadding, y: 0, width: topBarView.frame.width - (topBarView.frame.width - notificationButton.frame.minX) - 2*titleLabelPadding, height: topBarView.frame.height);
        topBarTitleLabel = UITextView(frame: titleLabelFrame); // We need a container in order to account for multiple labels
        
        //topBarTitleLabel.backgroundColor = .systemOrange;
        topBarTitleLabel.isUserInteractionEnabled = false;
        topBarTitleLabel.isEditable = false;
        topBarTitleLabel.isSelectable = false;
        topBarTitleLabel.textAlignment = .left;
        //topBarTitleLabel.textColor = mainThemeColor;

        /*topBarTitleLabel.text = "Test Title";
        topBarTitleLabel.font = UIFont(name: "SFProDisplay-Semibold", size: topBarView.frame.height * 0.7);*/
        
        updateTopBar(selectedButtonIndex);
        
        topBarView.addSubview(topBarTitleLabel);
        
        //
        
        /*topBarHomeView = UIView(frame: titleLabelFrame);
        
        //topBarHomeView.backgroundColor = .systemBlue;
        
        
        
        topBarView.addSubview(topBarHomeView);*/
        
    }
    
}
