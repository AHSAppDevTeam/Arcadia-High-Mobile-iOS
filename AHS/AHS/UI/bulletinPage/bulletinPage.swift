//
//  bulletinPage.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

class bulletinPageViewController : mainPageViewController{
    
    init(){
        super.init(nibName: nil, bundle: nil);
        self.pageName = "Student";
        self.secondaryPageName = "Bulletin";
        self.viewControllerIconName = "doc.plaintext.fill";
    }
    
    required init?(coder: NSCoder) { // required uiviewcontroller init
        super.init(coder: coder);
    }
    
    //
    
    internal let mainScrollView : UIScrollView = UIScrollView();
    
    internal let refreshControl : UIRefreshControl = UIRefreshControl();

    internal let categoryScrollView : UIScrollView = UIScrollView();
    
    internal let comingUpLabel : UILabel = UILabel();
    internal let comingUpContentView : UIView = UIView();
    internal var comingUpContentViewHeightConstraint : NSLayoutConstraint = NSLayoutConstraint();
    
    internal let bulletinContentView : UIView = UIView();
    internal var bulletinContentViewHeightConstraint : NSLayoutConstraint = NSLayoutConstraint();
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if (!self.hasBeenSetup){
            
            mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
            mainScrollView.alwaysBounceVertical = true;
            self.view.addSubview(mainScrollView);
            
            mainScrollView.addSubview(refreshControl);
            refreshControl.addTarget(self, action: #selector(self.refresh), for: .touchUpInside);
            
            self.renderLayout();
            
            self.hasBeenSetup = true;
        }
        
    }
    
    internal func renderLayout(){
        
        let verticalPadding : CGFloat = 5;
        let horizontalPadding : CGFloat = 10;
        
        //
        
        let categoryScrollViewWidth = mainScrollView.frame.width;
        let categoryScrollViewHeight = categoryScrollViewWidth * 0.26;
    
        mainScrollView.addSubview(categoryScrollView);
        categoryScrollView.translatesAutoresizingMaskIntoConstraints = false;
        
        categoryScrollView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true;
        categoryScrollView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        categoryScrollView.widthAnchor.constraint(equalToConstant: categoryScrollViewWidth).isActive = true;
        categoryScrollView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor).isActive = true;
        categoryScrollView.heightAnchor.constraint(equalToConstant: categoryScrollViewHeight).isActive = true;
        
        categoryScrollView.backgroundColor = .systemRed;
        
        //
        
        mainScrollView.addSubview(comingUpLabel);
        comingUpLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        let comingUpLabelWidth = mainScrollView.frame.width;
        let comingUpLabelHeight = comingUpLabelWidth * 0.13;
        
        comingUpLabel.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: horizontalPadding).isActive = true;
        comingUpLabel.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: verticalPadding).isActive = true;
        comingUpLabel.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        comingUpLabel.heightAnchor.constraint(equalToConstant: comingUpLabelHeight).isActive = true;
        
        
        let comingUpAttributedText = NSMutableAttributedString(string: "Coming ", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: comingUpLabelHeight * 0.5)]);
        comingUpAttributedText.append(NSAttributedString(string: "Up", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Regular, size: comingUpLabelHeight * 0.5)]));
        
        comingUpLabel.attributedText = comingUpAttributedText;
        comingUpLabel.textColor = UIColor.init(hex: "#d8853d");
        comingUpLabel.textAlignment = .left;
        //comingUpLabel.backgroundColor = .systemBlue;
        
        //
        
        mainScrollView.addSubview(comingUpContentView);
        comingUpContentView.translatesAutoresizingMaskIntoConstraints = false;
        
        comingUpContentView.topAnchor.constraint(equalTo: comingUpLabel.bottomAnchor, constant: verticalPadding).isActive = true;
        comingUpContentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: horizontalPadding).isActive = true;
        comingUpContentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        
        comingUpContentViewHeightConstraint = comingUpContentView.heightAnchor.constraint(equalToConstant: 0);
        comingUpContentViewHeightConstraint.isActive = true;
        
        //
        
        mainScrollView.addSubview(bulletinContentView);
        bulletinContentView.translatesAutoresizingMaskIntoConstraints = false;
        
        bulletinContentView.topAnchor.constraint(equalTo: comingUpContentView.bottomAnchor, constant: verticalPadding).isActive = true;
        bulletinContentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: horizontalPadding).isActive = true;
        bulletinContentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        
        bulletinContentViewHeightConstraint = bulletinContentView.heightAnchor.constraint(equalToConstant: 0);
        bulletinContentViewHeightConstraint.isActive = true;
        
        bulletinContentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -verticalPadding).isActive = true;
        
        
    }
}

