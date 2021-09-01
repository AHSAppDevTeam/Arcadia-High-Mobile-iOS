//
//  profilePage.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

class profilePageViewController : mainPageViewController{
    
    internal let mainScrollView : UIButtonScrollView = UIButtonScrollView();
    
    internal let refreshControl : UIRefreshControl = UIRefreshControl();
    
    //
    
    internal let idCardButton : IDButton = IDButton();
    internal var idCardButtonWidth : CGFloat = 0; // set on runtime
    internal var idCardButtonHeight : CGFloat = 0;
    
    //internal let shopButton : UIButton = UIButton(); -- for later
    
    internal let contentTableView : UITableView = UITableView();
    internal var contentTableViewHeightConstraint : NSLayoutConstraint = NSLayoutConstraint();
    static internal let contentTableViewSectionHeight : CGFloat = 40;
    static internal let contentTableViewRowHeight : CGFloat = 45;
    
    internal let contentTableViewSectionCount : Int = 3;
    
    static internal let scheduleViewHeight : CGFloat = 100;
    internal let scheduleView : UIView = UIView();
    
    internal let optionsCellTitles = ["Notifications", "ID Card"];
    internal let infoCellTitles = ["About Us", "Terms and Agreements", "App Version"];
    
    internal let tableViewContentViewControllers = [[notificationSettingsPageViewController(), idCardSettingsPageViewController()], [aboutUsPageViewController(), termsAndConditionsPageViewController()]];
    
    internal var contentTableViewCellTitles : [[String]] = []; // gets populated with optionsCellTitles and infoCellTitles
    internal var contentTableViewCellValues : [[String?]] = [];
    
    //
    
    static public let horizontalPadding : CGFloat = 10;
    static public let verticalPadding : CGFloat = 5;
    
    //
    
    internal let backgroundIDGradient = CAGradientLayer();
    
    internal var backgroundIDGradientSet = [[CGColor]]();
    internal var backgroundIDCurrentGradient: Int = 0;
    
    //
    
    internal var transitionDelegateVar : transitionDelegate!;
    
    //
    
    init(){
        super.init(nibName: nil, bundle: nil);
        self.pageName = "Your";
        self.secondaryPageName = "Profile";
        self.viewControllerIconName = "person.circle.fill";
    }
    
    required init?(coder: NSCoder) { // required uiviewcontroller init
        super.init(coder: coder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if (!self.hasBeenSetup){
            
            setupTableViewContent();
                    
            guard contentTableViewCellTitles.count != contentTableViewSectionCount else{
                print("contentTableViewCellTitles count does not match contentTableViewSectionCount");
                return;
            }
            
            //
            
            mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
            mainScrollView.alwaysBounceVertical = true;
            mainScrollView.backgroundColor = BackgroundColor
            
            self.view.addSubview(mainScrollView);
            
            //
            
            refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged);
            mainScrollView.addSubview(refreshControl);
            
            //
            
            renderContent();
            
            //
            
            self.hasBeenSetup = true;
        }
        
        animateIDBackgroundGradient();

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        backgroundIDGradient.frame = idCardButton.bounds;
    }
    
    private func setupTableViewContent(){
        contentTableViewCellTitles = [optionsCellTitles, infoCellTitles];
        
        contentTableViewCellValues = [Array(repeating: nil, count: optionsCellTitles.count), Array(repeating: nil, count: infoCellTitles.count)];
        contentTableViewCellValues[1][infoCellTitles.count - 1] = AppUtility.getAppVersionString(); // set app build number
    }
    
    internal func renderContent(){
        
        mainScrollView.addSubview(idCardButton);
        
        idCardButton.translatesAutoresizingMaskIntoConstraints = false;
        
        idCardButton.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: profilePageViewController.horizontalPadding).isActive = true;
        idCardButton.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: profilePageViewController.verticalPadding).isActive = true;
        idCardButton.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -profilePageViewController.horizontalPadding).isActive = true;
        
        idCardButtonWidth = mainScrollView.frame.width - 2*profilePageViewController.horizontalPadding;
        idCardButtonHeight = idCardButtonWidth * 0.562;
        
        idCardButton.widthAnchor.constraint(equalToConstant: idCardButtonWidth).isActive = true;
        idCardButton.heightAnchor.constraint(equalToConstant: idCardButtonHeight).isActive = true;
        
        idCardButton.clipsToBounds = true;
        idCardButton.layer.cornerRadius = 12;
        idCardButton.addTarget(self, action: #selector(self.handleIDCardPress), for: .touchUpInside);
        
        idCardButton.backgroundColor = .systemOrange;
        
        idCardButton.idState = .isUnlocked;
        
        renderIDCard();
        
        setupIDBackgroundGradient();
        
        //
        
        mainScrollView.addSubview(contentTableView);
        
        contentTableView.translatesAutoresizingMaskIntoConstraints = false;
        
        contentTableView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: profilePageViewController.horizontalPadding).isActive = true;
        contentTableView.topAnchor.constraint(equalTo: idCardButton.bottomAnchor, constant: 2*profilePageViewController.verticalPadding).isActive = true;
        contentTableView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -profilePageViewController.horizontalPadding).isActive = true;
        contentTableView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -profilePageViewController.verticalPadding).isActive = true;
        
        contentTableViewHeightConstraint = contentTableView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 2); // https://stackoverflow.com/a/40081129
        contentTableViewHeightConstraint.isActive = true;
        
        contentTableView.delegate = self;
        contentTableView.dataSource = self;
        contentTableView.isScrollEnabled = false;
        contentTableView.register(profilePageTableViewCell.self, forCellReuseIdentifier: profilePageTableViewCell.identifier);
        
        UIView.animate(withDuration: 0, animations: {
            self.contentTableView.layoutIfNeeded();
        }, completion: { _ in
                    
            var height : CGFloat = 0;
            
            for cell in self.contentTableView.visibleCells{
                height += cell.frame.height;
            }
            
            height += CGFloat(self.contentTableView.numberOfSections) * profilePageViewController.contentTableViewSectionHeight;
                    
            self.contentTableViewHeightConstraint.constant = height;
            
        });
        
    }
    
}
