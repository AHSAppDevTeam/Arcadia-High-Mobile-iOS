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
    internal let contentViewControllers : [mainPageViewController] = [homePageViewController(), bulletinPageViewController(), savedPageViewController(), profilePageViewController()];
    
    // Navigation Bar View
    internal let buttonArraySize = 4;
    internal var buttonViewArray : [UIButton] = Array(repeating: UIButton(), count: 4);
    internal var navigationBarView : UIView = UIView();
    
    internal var selectedButtonIndex : Int = 0;
    
    // Top Bar View
    internal var topBarView : UIView = UIView();
    internal var topBarHomeView : UIView = UIView();
    internal var topBarHomeImageView : UIImageView = UIImageView();
    internal var topBarTitleLabel : UITextView = UITextView();
    
    //
    internal var transitionDelegateVar : transitionDelegate!;
    
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
        vc.willMove(toParent: self);
        addChild(vc);
        vc.view.frame = contentView.bounds;
        contentView.addSubview(vc.view);
        vc.didMove(toParent: self);
        
        updateTopBar(selectedButtonIndex); // should be 0
        
        self.hideKeyboardWhenTappedAround();
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.openArticlePage), name: NSNotification.Name(rawValue: articlePageNotification), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.openSchedulePage), name: NSNotification.Name(rawValue: schedulePageNotification), object: nil);
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: articlePageNotification), object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: schedulePageNotification), object: nil);
    }
    
    private func renderNavigationBar(){
        
        let navigationBarViewHeight = CGFloat(AppUtility.getCurrentScreenSize().width * (25/207)) + AppUtility.safeAreaInset.bottom;
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
        
        topBarHomeView = UIView(frame: titleLabelFrame);
        
        topBarView.addSubview(topBarHomeView);

        //topBarHomeView.backgroundColor = .systemBlue;
        
        //
        
        let topBarHomeTitleLabelText = "Arcadia";
        let topBarHomeTitleLabelFont = UIFont(name: SFProDisplay_Bold, size: topBarHomeView.frame.height * 0.5)!;
        let topBarHomeTitleLabelHeight = topBarHomeView.frame.height / 2;
        let topBarHomeTitleLabelWidth = topBarHomeTitleLabelText.width(withConstrainedHeight: topBarHomeTitleLabelHeight, font: topBarHomeTitleLabelFont);
        let topBarHomeTitleLabelFrame = CGRect(x: 0, y: 0, width: topBarHomeView.frame.width, height: topBarHomeTitleLabelHeight);
        let topBarHomeTitleLabel = UILabel(frame: topBarHomeTitleLabelFrame);
        
        topBarHomeTitleLabel.text = topBarHomeTitleLabelText;
        topBarHomeTitleLabel.textColor = mainThemeColor;
        topBarHomeTitleLabel.font = topBarHomeTitleLabelFont;
        topBarHomeTitleLabel.textAlignment = .left;
        //topBarHomeTitleLabel.backgroundColor = .systemOrange;
        
        topBarHomeView.addSubview(topBarHomeTitleLabel);
        
        //
        
        let topBarHomeDateLabelFrame = CGRect(x: 0, y: topBarHomeView.frame.height / 2, width: topBarHomeView.frame.width, height: topBarHomeView.frame.height / 2);
        let topBarHomeDateLabel = UITextView(frame: topBarHomeDateLabelFrame);
        
        topBarHomeDateLabel.isUserInteractionEnabled = false;
        topBarHomeDateLabel.isEditable = false;
        topBarHomeDateLabel.isSelectable = false;
        topBarHomeDateLabel.textAlignment = .left;
        
        let topBarHomeDateText = NSMutableAttributedString(string: timeManager.getMonthString(), attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Medium, size: topBarHomeDateLabel.frame.height * 0.7)]);
        
        topBarHomeDateText.append(NSAttributedString(string: " " + timeManager.getDateString(), attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Light, size: topBarHomeDateLabel.frame.height * 0.7)]));
        
        topBarHomeDateLabel.attributedText = topBarHomeDateText;
        topBarHomeDateLabel.textColor = mainThemeColor;
        topBarHomeDateLabel.textContainerInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0);
        topBarHomeDateLabel.textContainer.lineFragmentPadding = .zero;
        //topBarHomeDateLabel.centerTextVertically();

        //topBarHomeDateLabel.backgroundColor = .systemBlue;
        
        topBarHomeView.addSubview(topBarHomeDateLabel);
        
        //
        
        let topBarHomeImageViewFrame = CGRect(x: 0, y: 0, width: topBarHomeTitleLabelWidth, height: topBarHomeView.frame.height);
        topBarHomeImageView = UIImageView(frame: topBarHomeImageViewFrame);
        
        topBarHomeImageView.image = UIImage(named: "icon_no_bg");
        topBarHomeImageView.contentMode = .scaleAspectFit;
        topBarHomeImageView.alpha = 0.5;
        
        topBarHomeView.addSubview(topBarHomeImageView);

    }
    
}
