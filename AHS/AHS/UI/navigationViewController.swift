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
    private var contentView : UIView = UIView();
    private let contentViewControllers : [pageViewController] = [homePageViewController(), bulletinPageViewController(), savedPageViewController(), profilePageViewController()];
    
    // Navigation Bar View
    private let buttonArraySize = 4;
    private var buttonViewArray : [UIButton] = Array(repeating: UIButton(), count: 4);
    private var navigationBarView : UIView = UIView();
    
    private var selectedButtonIndex : Int = 0;
    
    // Top Bar View
    private var topBarView : UIView = UIView();
    private var topBarLabel : UILabel = UILabel();
    private var topBarHomeView : UIView = UIView();
    private var topBarNotificationButton : UIButton = UIButton();
    
    
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
        
        for i in 0..<4{
            let button = UIButton();
            
            button.setImage(UIImage(systemName: navigationBarButtonSystemIconNames[i]), for: .normal);
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
        
    }
    
    // After setup functions
    
    @objc func changePage(_ sender: UIButton){
        //print("button press id \(sender.tag)");
        let prevIndex = selectedButtonIndex;
        selectedButtonIndex = sender.tag;
        
        selectButton(sender);
        unselectButton(buttonViewArray[prevIndex]);
        
        updateTopBar(selectedButtonIndex);
        updateContentView(selectedButtonIndex, prevIndex);
        
    }
    
    @objc func openNotificationPage(_ sender: UIButton){
        print("open notifications page");
    }
    
    private func selectButton(_ button: UIButton){
        button.isSelected = true;
        button.tintColor = NavigationButtonSelectedColor;
    }
    
    private func unselectButton(_ button: UIButton){
        button.isSelected = false;
        button.tintColor = NavigationButtonUnselectedColor;
    }
    
    private func updateTopBar(_ pageIndex: Int){
        
    }
    
    private func updateContentView(_ pageIndex: Int, _ prevIndex: Int){
        
        // remove prev view controller
        let prevVC = contentViewControllers[prevIndex];
        prevVC.willMove(toParent: nil);
        prevVC.view.removeFromSuperview();
        prevVC.removeFromParent();
        
        // add new view controller
        let vc = contentViewControllers[selectedButtonIndex];
        vc.willMove(toParent: self);
        addChild(vc);
        vc.view.frame = contentView.bounds;
        contentView.addSubview(vc.view);
        vc.didMove(toParent: self);
        
    }
    
}
