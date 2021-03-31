//
//  homePage.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

class homePageViewController : mainPageViewController{
    
    init(){
        super.init(nibName: nil, bundle: nil);
        self.pageName = "Home";
        self.viewControllerIconName = "house.fill";
    }
    
    required init?(coder: NSCoder) { // required uiviewcontroller init
        super.init(coder: coder);
    }
    
    //
    
    internal var mainScrollView : UIScrollView = UIScrollView();
    
    // main scrollview views
    
    internal var topCatagoryPickerView : UIView = UIView();
    internal var topCatagoryPickerViewHeightAnchor : NSLayoutConstraint = NSLayoutConstraint();
    
    internal var featuredCategoryView : UIView = UIView();
    internal var featuredCategoryViewHeightAnchor : NSLayoutConstraint = NSLayoutConstraint();
    
    internal var contentView : UIView = UIView();
    internal var contentViewHeightAnchor : NSLayoutConstraint = NSLayoutConstraint();
    internal let contentViewControllers : [homeContentPageViewController] = [newsPageController(), communityPageController()];
    internal var contentViewControllerIndex : Int = -1;
    
    //
    
    internal var newsButton : UIButton = UIButton();
    internal let newsButtonColor = UIColor.rgb(199, 67, 53);
    internal var communityButton : UIButton = UIButton();
    internal let communityButtonColor = UIColor.rgb(72, 153, 146);
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if (!self.hasBeenSetup){
            self.view.backgroundColor = BackgroundColor;
            
            mainScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height));
            //mainScrollView.backgroundColor = .systemBlue;
            
            self.view.addSubview(mainScrollView);
            
            setupLayout();
            setupTopCategory();
            
            self.hasBeenSetup = true;
        }
        
    }
    
    private func setupLayout(){
        
        //top category
        mainScrollView.addSubview(topCatagoryPickerView);
        
        // constraints
        topCatagoryPickerView.translatesAutoresizingMaskIntoConstraints = false;
        topCatagoryPickerView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        topCatagoryPickerView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true;
        topCatagoryPickerView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true;
        //topCatagoryPickerView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true;
        
        topCatagoryPickerViewHeightAnchor = topCatagoryPickerView.heightAnchor.constraint(equalToConstant: 0);
        topCatagoryPickerViewHeightAnchor.isActive = true;
        
        //
        
        mainScrollView.addSubview(featuredCategoryView);
        featuredCategoryView.backgroundColor = .systemGreen;
        
        featuredCategoryView.translatesAutoresizingMaskIntoConstraints = false;
        featuredCategoryView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        featuredCategoryView.topAnchor.constraint(equalTo: topCatagoryPickerView.bottomAnchor).isActive = true;
        featuredCategoryView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true;
        
        featuredCategoryViewHeightAnchor = featuredCategoryView.heightAnchor.constraint(equalToConstant: 0);
        featuredCategoryViewHeightAnchor.isActive = true;
        
        //
        
        mainScrollView.addSubview(contentView);
        contentView.backgroundColor = .systemOrange;
        
        contentView.translatesAutoresizingMaskIntoConstraints = false;
        contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        contentView.topAnchor.constraint(equalTo: featuredCategoryView.bottomAnchor).isActive = true;
        contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true;
        contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true;
        
        contentViewHeightAnchor = contentView.heightAnchor.constraint(equalToConstant: 0);
        contentViewHeightAnchor.isActive = true;
    }
    
    private func setupTopCategory(){
        let topCategoryHeight = self.view.frame.height / 10;
        topCatagoryPickerViewHeightAnchor.constant = topCategoryHeight;
        
        let horizontalPadding = self.view.frame.width / 8;
        let verticalPadding = topCatagoryPickerViewHeightAnchor.constant / 6;
        let buttonWidth = (self.view.frame.width - 3 * horizontalPadding) / 2;
        
        //
        
        let newsButtonFrame = CGRect(x: horizontalPadding, y: verticalPadding, width: buttonWidth, height: topCatagoryPickerViewHeightAnchor.constant - 2*verticalPadding);
        newsButton.frame = newsButtonFrame;
        
        newsButton.backgroundColor = .clear;
        newsButton.layer.cornerRadius = newsButton.frame.height / 2;
        newsButton.layer.borderWidth = 2;
        newsButton.layer.borderColor = newsButtonColor.cgColor;
        
        newsButton.setTitle("AUSD News", for: .normal);
        newsButton.titleLabel?.font = UIFont(name: SFCompactDisplay_Light, size: newsButton.frame.height * 0.4);
        newsButton.setTitleColor(newsButtonColor, for: .normal);
        
        newsButton.addTarget(self, action: #selector(self.selectCategoryButton), for: .touchUpInside);
        
        newsButton.tag = 1;
        topCatagoryPickerView.addSubview(newsButton);
        
        //
        
        let communityButtonFrame = CGRect(x: newsButton.frame.maxX + horizontalPadding, y: verticalPadding, width: buttonWidth, height: topCatagoryPickerViewHeightAnchor.constant - 2*verticalPadding);
        communityButton.frame = communityButtonFrame;
        
        communityButton.backgroundColor = .clear;
        communityButton.layer.cornerRadius = communityButton.frame.height / 2;
        communityButton.layer.borderWidth = 2;
        communityButton.layer.borderColor = communityButtonColor.cgColor;
        
        communityButton.setTitle("Community", for: .normal);
        communityButton.titleLabel?.font = UIFont(name: SFCompactDisplay_Light, size: communityButton.frame.height * 0.4);
        communityButton.setTitleColor(communityButtonColor, for: .normal);
        
        communityButton.addTarget(self, action: #selector(self.selectCategoryButton), for: .touchUpInside);
        
        communityButton.tag = 2;
        topCatagoryPickerView.addSubview(communityButton);
        
        selectCategoryButton(newsButton);
        
    }

    
}
