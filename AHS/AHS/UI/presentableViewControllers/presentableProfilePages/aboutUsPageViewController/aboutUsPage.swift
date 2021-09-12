//
//  aboutUsPageViewController.swift
//  AHS
//
//  Created by Richard Wei on 8/29/21.
//

import Foundation
import UIKit

class aboutUsPageViewController : presentableViewController{
    
    internal let mainScrollView :  UIButtonScrollView = UIButtonScrollView();
    internal let refreshControl : UIRefreshControl = UIRefreshControl();
    
    //
    
    internal let backgroundGradient = CAGradientLayer();
    
    internal var backgroundGradientSet = [[CGColor]]();
    internal var backgroundCurrentGradient: Int = 0;
    
    //
    
    internal let dismissButton : UIButton = UIButton();
    
    internal let dismissImageView : UIImageView = UIImageView();
    
    //
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
        self.setupPanGesture();
        
        self.view.backgroundColor = BackgroundColor;
        
        //
        
        let dismissButtonWidth = self.view.frame.width;
        let dismissButtonHeight = dismissButtonWidth * 0.09;
        
        dismissButton.frame = CGRect(x: 0, y: AppUtility.safeAreaInset.top, width: dismissButtonWidth, height: dismissButtonHeight);
        
        //
        
        let dismissImageViewHorizontalPadding : CGFloat = 10;
        let dismissImageViewVerticalPadding : CGFloat = 5;
        let dismissImageViewSize = dismissButton.frame.height - 2*dismissImageViewVerticalPadding;
        
        dismissImageView.frame = CGRect(x: dismissImageViewHorizontalPadding, y: dismissImageViewVerticalPadding, width: dismissImageViewSize, height: dismissImageViewSize);
        
        dismissImageView.image = UIImage(systemName: "chevron.left");
        dismissImageView.contentMode = .scaleAspectFit;
        dismissImageView.tintColor = InverseBackgroundColor;
        
        dismissButton.addSubview(dismissImageView);
        
        //
        
        dismissButton.addTarget(self, action: #selector(self.handleBackButton), for: .touchUpInside);
        
        self.view.addSubview(dismissButton);
        
        //
        
        mainScrollView.frame = CGRect(x: 0, y: dismissButton.frame.height + AppUtility.safeAreaInset.top, width: self.view.frame.width, height: self.view.frame.height - dismissButton.frame.height - AppUtility.safeAreaInset.top);
        mainScrollView.alwaysBounceVertical = true;
        mainScrollView.addSubview(refreshControl);
        
        self.view.addSubview(mainScrollView);
        
        //
        
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged);
        refreshControl.beginRefreshing();
        
        loadCreditsList();
        
        //
        
        setupBackgroundGradient();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        animateBackgroundGradient();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        backgroundGradient.frame = self.view.bounds;
    }
    
    //
    
    internal func loadCreditsList(){
        
        for subview in mainScrollView.subviews{
            if (subview.tag == 1){
                subview.removeFromSuperview();
            }
        }
        
        dataManager.getCreditsList(completion: { (creditList) in
            self.refreshControl.endRefreshing();
            self.renderCreditsList(self.sortCreditsList(creditList));
            //self.renderCreditsList(creditList);
            //print(creditList);
        });
    }
    
    internal func sortCreditsList(_ creditList: [creditData]) -> [creditCategory]{
        let categoryList = creditCategory.getCategoryList();
        var categories : [creditCategory] = Array(repeating: creditCategory(), count: categoryList.count);
        
        for i in 0..<categories.count{
            categories[i].title = categoryList[i];
        }
        
        for person in creditList{
            categories[creditCategory.getCategoryIndex(person.retired ? creditRole.none : person.role)].list.append(person);
        }
        
        return categories;
    }
    
    internal func renderCreditsList(_ credits: [creditCategory]){
        // for each category check if list size if bigger than 0
        //print(credits)
        
        for category in credits{
            
            if (category.list.count == 0){
                continue;
            }
            
            print("category - \(category.title)")
            
            //
            
            
            
            //
            
            for person in category.list{
                print(person.name);
            }
            
        }
        
    }
    
}
