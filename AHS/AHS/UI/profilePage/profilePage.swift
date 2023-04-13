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
    static internal let contentTableViewSectionHeaderHeight : CGFloat = 40;
    static internal let contentTableViewRowHeightRatio : CGFloat = 0.105; // in relation to the screen width
    
    internal let contentTableViewSectionCount : Int = 3;
    
    static internal let scheduleViewHeightRatio : CGFloat = 2.22; // in relation to contentTableViewRowHeightRatio
    internal let scheduleView : UIView = UIView();
    internal var scheduleViewWidth : CGFloat = 0; // set on runtime
    internal var scheduleViewHeight : CGFloat = 0;
    internal var scheduleUpdaterTimer : Timer = Timer(); // set on viewDidAppear
    
    //static internal let optionsCellTitles = ["Notifications", "ID Card"]; -- with id card
    static internal let optionsCellTitles = ["Notifications"];
    static internal let infoCellTitles = ["About Us", "Terms and Agreements", "App Version"];
    
    //internal let tableViewContentViewControllers = [[notificationSettingsPageViewController(), idCardSettingsPageViewController()], [aboutUsPageViewController(), termsAndConditionsPageViewController()]]; -- with id card
    internal let tableViewContentViewControllers = [[notificationSettingsPageViewController()], [aboutUsPageViewController(), termsAndConditionsPageViewController()]];
    
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
    
    internal let backgroundScheduleGradient = CAGradientLayer();
    
    internal var backgroundScheduleGradientSet = [[CGColor]]();
    internal var backgroundScheduleCurrentGradient : Int = 0;
    
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
        
        animateBackgroundIDGradient();

        NotificationCenter.default.addObserver(self, selector: #selector(self.resetContentOffset), name: NSNotification.Name(rawValue: setScrollViewZeroContentOffset), object: nil);
        
        scheduleUpdaterTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.loadSchedule), userInfo: nil, repeats: true);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: setScrollViewZeroContentOffset), object: nil);
        
        scheduleUpdaterTimer.invalidate();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        //print("content table view size - \(self.contentTableView.contentSize)");
        self.contentTableViewHeightConstraint.constant = self.contentTableView.contentSize.height;
    }
    
    private func setupTableViewContent(){
        contentTableViewCellTitles = [profilePageViewController.optionsCellTitles, profilePageViewController.infoCellTitles];
        
        contentTableViewCellValues = [Array(repeating: nil, count: profilePageViewController.optionsCellTitles.count), Array(repeating: nil, count: profilePageViewController.infoCellTitles.count)];
        contentTableViewCellValues[1][profilePageViewController.infoCellTitles.count - 1] = AppUtility.getAppVersionString(); // set app build number
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
        //idCardButton.addTarget(self, action: #selector(self.handleIDCardPress), for: .touchUpInside);
    
        let idCardButtonTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleIDCardPress));
        idCardButtonTapGestureRecognizer.numberOfTapsRequired = 1;
        idCardButton.addGestureRecognizer(idCardButtonTapGestureRecognizer);
        
        let idCardButtonLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleIDCardLongPress));
        idCardButton.addGestureRecognizer(idCardButtonLongPressGestureRecognizer);
    
        
        idCardButton.backgroundColor = .systemOrange;
        
        idCardButton.idState = .isUnlocked;
        
        renderIDCard();
        
        setupIDBackgroundGradient();
        
        //
        
        mainScrollView.addSubview(contentTableView);
        
        contentTableView.translatesAutoresizingMaskIntoConstraints = false;
        
        contentTableView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: profilePageViewController.horizontalPadding).isActive = true;
        contentTableView.topAnchor.constraint(equalTo: idCardButton.bottomAnchor, constant: profilePageViewController.verticalPadding).isActive = true;
        contentTableView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -profilePageViewController.horizontalPadding).isActive = true;
        contentTableView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -profilePageViewController.verticalPadding).isActive = true;
        
        contentTableView.delegate = self;
        contentTableView.dataSource = self;
        contentTableView.isScrollEnabled = false;
        contentTableView.register(profilePageTableViewCell.self, forCellReuseIdentifier: profilePageTableViewCell.identifier);
        
        contentTableViewHeightConstraint = contentTableView.heightAnchor.constraint(equalToConstant: 1000);
        contentTableViewHeightConstraint.isActive = true;

        self.contentTableView.layoutIfNeeded();
        
        /*UIView.animate(withDuration: 0, animations: {  // https://stackoverflow.com/a/40081129
            self.contentTableView.layoutIfNeeded();
        }, completion: { _ in
                    
            var height : CGFloat = 0;
            
            for cell in self.contentTableView.visibleCells{
                height += cell.frame.height;
            }
            
            height += CGFloat(self.contentTableView.numberOfSections) * profilePageViewController.contentTableViewSectionHeight;
                    
            //print("visible cells count - \(self.contentTableView.visibleCells.count)");
            
            self.contentTableViewHeightConstraint.constant = height;
            
        });*/
        
    }
    
}


extension profilePageViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            backgroundIDGradient.colors = backgroundIDGradientSet[backgroundIDCurrentGradient];
            animateBackgroundIDGradient();

            //backgroundScheduleGradient.colors = backgroundScheduleGradientSet[backgroundScheduleCurrentGradient];
            //animateBackgroundScheduleGradient();
        }
    }
}
