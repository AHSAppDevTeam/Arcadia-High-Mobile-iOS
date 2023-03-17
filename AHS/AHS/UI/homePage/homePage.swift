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
        //self.pageName = "";
        self.viewControllerIconName = "house.fill";
    }
    
    required init?(coder: NSCoder) { // required uiviewcontroller init
        super.init(coder: coder);
    }
    
    //
    
    internal var mainScrollView : UIButtonScrollView = UIButtonScrollView();
    
    // main scrollview views
    
    internal var topCategoryPickerView : UIView = UIView();
    internal var topCategoryPickerViewHeightAnchor : NSLayoutConstraint = NSLayoutConstraint();
    
    internal var featuredCategoryView : UIView = UIView();
    public var featuredCategoryViewHeightAnchor : NSLayoutConstraint = NSLayoutConstraint();
    internal let featuredCategoryController : homeContentPageViewController = featuredCategoryViewController();
    
    internal var contentView : UIView = UIView();
    public var contentViewHeightAnchor : NSLayoutConstraint = NSLayoutConstraint();
    internal let contentViewControllers : [homeContentPageViewController] = [newsPageController(), communityPageController()];
    internal var contentViewControllerIndex : Int = -1;
    
    //
    
    internal var newsButton : UIButton = UIButton();
    internal let newsButtonColor = UIColor.rgb(199, 67, 53);
    internal var communityButton : UIButton = UIButton();
    internal let communityButtonColor = UIColor.rgb(72, 153, 146);
    internal var searchButton : UIButton = UIButton();
    internal let searchButtonColor = UIColor.rgb(199, 67, 53);
    
    internal var topCategoryPickerButtons : [UIButton] = [];
    internal var topCategoryPickerButtonColors : [UIColor] = [];
    
    //
    
    internal let refreshControl = UIRefreshControl();
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if (!self.hasBeenSetup){
            self.view.backgroundColor = BackgroundColor;
            
            mainScrollView = UIButtonScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height));
            mainScrollView.alwaysBounceVertical = true;
            
            self.view.addSubview(mainScrollView);
            
            mainScrollView.addSubview(refreshControl);
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged);
            
            refreshControl.beginRefreshing();
            
            setupLayout();
            setupTopCategory();
            setupFeaturedCategory();
            
            self.hasBeenSetup = true;
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.endRefreshing) ,name: NSNotification.Name(rawValue: homePageEndRefreshing), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.beginRefreshing), name: NSNotification.Name(rawValue: homePageBeginRefreshing), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.resetContentOffset), name: NSNotification.Name(rawValue: setScrollViewZeroContentOffset), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.endRefreshing) ,name: NSNotification.Name(rawValue: endDataManagerRefreshing), object: nil);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        
        self.refreshControl.endRefreshing();
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: homePageEndRefreshing), object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: homePageBeginRefreshing), object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: setScrollViewZeroContentOffset), object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: endDataManagerRefreshing), object: nil);
    }
    
    private func setupLayout(){
        
        let verticalPadding = CGFloat(10);
        
        //top category
        mainScrollView.addSubview(topCategoryPickerView);
        
        // constraints
        topCategoryPickerView.translatesAutoresizingMaskIntoConstraints = false;
        topCategoryPickerView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        topCategoryPickerView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true;
        let topCategoryConstraint = topCategoryPickerView.topAnchor.constraint(equalTo: mainScrollView.topAnchor);
        topCategoryConstraint.isActive = true;
        topCategoryConstraint.constant = verticalPadding;
        //topCatagoryPickerView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true;
        
        topCategoryPickerViewHeightAnchor = topCategoryPickerView.heightAnchor.constraint(equalToConstant: 0);
        topCategoryPickerViewHeightAnchor.isActive = true;
        
        //
        
        mainScrollView.addSubview(featuredCategoryView);
        
        featuredCategoryView.translatesAutoresizingMaskIntoConstraints = false;
        featuredCategoryView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        featuredCategoryView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true;
        let featuredCategoryConstraint = featuredCategoryView.topAnchor.constraint(equalTo: topCategoryPickerView.bottomAnchor);
        featuredCategoryConstraint.isActive = true;
        featuredCategoryConstraint.constant = verticalPadding;
        
        featuredCategoryViewHeightAnchor = featuredCategoryView.heightAnchor.constraint(equalToConstant: 0);
        featuredCategoryViewHeightAnchor.isActive = true;
        
        //
        
        mainScrollView.addSubview(contentView);
        
        contentView.translatesAutoresizingMaskIntoConstraints = false;
        contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true;
        contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true;
        let contentViewConstraint = contentView.topAnchor.constraint(equalTo: featuredCategoryView.bottomAnchor);
        contentViewConstraint.isActive = true;
        contentViewConstraint.constant = verticalPadding;
        
        contentViewHeightAnchor = contentView.heightAnchor.constraint(equalToConstant: 0);
        contentViewHeightAnchor.isActive = true;
    }
    
    private func setupTopCategory(){
        
        topCategoryPickerButtons = [newsButton, communityButton, searchButton];
        topCategoryPickerButtonColors = [newsButtonColor, communityButtonColor, searchButtonColor];
        
        //
        
        let topCategoryHeight = self.view.frame.height / 15;
        topCategoryPickerViewHeightAnchor.constant = topCategoryHeight;
        
        let outerHorizontalPadding = homePageHorizontalPadding;
        let innerHorizontalPadding = outerHorizontalPadding * (3/4);
        
        let searchButtonSize = topCategoryHeight; // perfect circle
        
        let buttonWidth = (self.view.frame.width - 2 * outerHorizontalPadding - 2 * innerHorizontalPadding - searchButtonSize) / 2;
        
        //
        
        let newsButtonFrame = CGRect(x: outerHorizontalPadding, y: 0, width: buttonWidth, height: topCategoryPickerViewHeightAnchor.constant);
        newsButton.frame = newsButtonFrame;
        
        newsButton.backgroundColor = .clear;
        newsButton.layer.cornerRadius = newsButton.frame.height / 2;
        newsButton.layer.borderWidth = 2;
        newsButton.layer.borderColor = newsButtonColor.cgColor;
        
        newsButton.setTitle("News", for: .normal);
        newsButton.titleLabel?.font = UIFont(name: SFProDisplay_Semibold, size: newsButton.frame.height * 0.4);
        newsButton.setTitleColor(newsButtonColor, for: .normal);
        
        newsButton.addTarget(self, action: #selector(self.selectCategoryButton), for: .touchUpInside);
        
        newsButton.tag = 0;
        topCategoryPickerView.addSubview(newsButton);
        
        //
        
        let communityButtonFrame = CGRect(x: newsButton.frame.maxX + innerHorizontalPadding, y: 0, width: buttonWidth, height: topCategoryPickerViewHeightAnchor.constant);
        communityButton.frame = communityButtonFrame;
        
        communityButton.backgroundColor = .clear;
        communityButton.layer.cornerRadius = communityButton.frame.height / 2;
        communityButton.layer.borderWidth = 2;
        communityButton.layer.borderColor = communityButtonColor.cgColor;
        
        communityButton.setTitle("Community", for: .normal);
        communityButton.titleLabel?.font = UIFont(name: SFProDisplay_Semibold, size: communityButton.frame.height * 0.4);
        communityButton.setTitleColor(communityButtonColor, for: .normal);
        
        communityButton.addTarget(self, action: #selector(self.selectCategoryButton), for: .touchUpInside);
        
        communityButton.tag = 1;
        topCategoryPickerView.addSubview(communityButton);
        
        //
        
        let searchButtonFrame = CGRect(x: communityButton.frame.maxX + innerHorizontalPadding, y: 0, width: searchButtonSize, height: searchButtonSize);
        searchButton.frame = searchButtonFrame;
        
        searchButton.backgroundColor = .clear;
        searchButton.layer.cornerRadius = searchButton.frame.height / 2;
        searchButton.layer.borderWidth = 2;
        searchButton.layer.borderColor = searchButtonColor.cgColor;
        
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal);
        searchButton.tintColor = searchButtonColor;
        
        searchButton.addTarget(self, action: #selector(self.selectCategoryButton), for: .touchUpInside);
        
        searchButton.tag = 2;
        topCategoryPickerView.addSubview(searchButton);
        
        //
        
        selectCategoryButton(newsButton);
        
    }

    private func setupFeaturedCategory(){
        
        featuredCategoryController.willMove(toParent: self);
        featuredCategoryController.view.frame = featuredCategoryView.bounds;
        featuredCategoryView.addSubview(featuredCategoryController.view);
        self.addChild(featuredCategoryController);
        featuredCategoryController.didMove(toParent: self);
        
        featuredCategoryViewHeightAnchor.constant = featuredCategoryController.getSubviewsMaxY();
        
    }
    
}
