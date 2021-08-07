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
    internal let contentTableViewSectionHeight : CGFloat = 30;
    
    internal let scheduleButton : UIButton = UIButton();
    
    //
    
    internal let horizontalPadding : CGFloat = 10;
    internal let verticalPadding : CGFloat = 5;
    
    //
    
    internal let backgroundIDGradient = CAGradientLayer();
    
    internal var backgroundIDGradientSet = [[CGColor]]();
    internal var backgroundIDCurrentGradient: Int = 0;
    
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
    
    
    internal func renderContent(){
        
        mainScrollView.addSubview(idCardButton);
        
        idCardButton.translatesAutoresizingMaskIntoConstraints = false;
        
        idCardButton.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: horizontalPadding).isActive = true;
        idCardButton.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: verticalPadding).isActive = true;
        idCardButton.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        
        idCardButtonWidth = mainScrollView.frame.width - 2*horizontalPadding;
        idCardButtonHeight = idCardButtonWidth * 0.562;
        
        idCardButton.widthAnchor.constraint(equalToConstant: idCardButtonWidth).isActive = true;
        idCardButton.heightAnchor.constraint(equalToConstant: idCardButtonHeight).isActive = true;
        
        idCardButton.clipsToBounds = true;
        idCardButton.layer.cornerRadius = idCardButtonHeight / 15;
        idCardButton.addTarget(self, action: #selector(self.handleIDCardPress), for: .touchUpInside);
        
        idCardButton.backgroundColor = .systemOrange;
        
        idCardButton.idState = .isUnlocked;
        
        renderIDCard();
        
        setupIDBackgroundGradient();
        
        //
        
        mainScrollView.addSubview(contentTableView);
        
        contentTableView.translatesAutoresizingMaskIntoConstraints = false;
        
        contentTableView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: horizontalPadding).isActive = true;
        contentTableView.topAnchor.constraint(equalTo: idCardButton.bottomAnchor, constant: 3*verticalPadding).isActive = true;
        contentTableView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        contentTableView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -verticalPadding).isActive = true;
        
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
            
            height += CGFloat(self.contentTableView.numberOfSections) * self.contentTableViewSectionHeight;
                    
            self.contentTableViewHeightConstraint.constant = height;
            
        });
        
    }
    
}
