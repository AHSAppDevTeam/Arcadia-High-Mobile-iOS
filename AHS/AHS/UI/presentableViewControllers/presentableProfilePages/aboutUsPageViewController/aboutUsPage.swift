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
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
        mainScrollView.alwaysBounceVertical = true;
        mainScrollView.addSubview(refreshControl);
        
        //mainScrollView.backgroundColor = .systemBlue;
        
        self.view.insertSubview(mainScrollView, at: 0);
        
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
        
        //
        
        var emailCreditData : creditData = creditData();
        emailCreditData.name = "dev@ahs.app";
        emailCreditData.url = URL(string: "mailto:dev@ahs.app");
        
        categories.insert(creditCategory(title: "Contact Us", list: [emailCreditData]), at: 0);
        
        //
        
        return categories;
    }
    
    internal func renderCreditsList(_ credits: [creditCategory]){
        // for each category check if list size if bigger than 0
        //print(credits)
        
        let categoryHorizontalPadding : CGFloat = mainScrollView.frame.width / 8;
        let categoryVerticalPadding : CGFloat = 40;
        
        var previousViewBottomAnchor : NSLayoutYAxisAnchor = mainScrollView.topAnchor;
        
        //
        
        for category in credits{
            
            if (category.list.count == 0){
                continue;
            }
            
            //print("category - \(category.title)")
            
            //
    
            let categoryView = UIView();
            
            mainScrollView.addSubview(categoryView);
            
            categoryView.translatesAutoresizingMaskIntoConstraints = false;
            
            categoryView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: categoryHorizontalPadding).isActive = true;
            categoryView.topAnchor.constraint(equalTo: previousViewBottomAnchor, constant: previousViewBottomAnchor == mainScrollView.topAnchor ? dismissButton.frame.height : categoryVerticalPadding).isActive = true;
            categoryView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -categoryHorizontalPadding).isActive = true;
            //categoryView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true;
            
            let categoryViewWidth = mainScrollView.frame.width - 2*categoryHorizontalPadding;
            
            categoryView.widthAnchor.constraint(equalToConstant: categoryViewWidth).isActive = true;
            //categoryView.heightAnchor.constraint(equalToConstant: 100).isActive = true;
            
            previousViewBottomAnchor = categoryView.bottomAnchor;
            
            categoryView.tag = 1;
            categoryView.clipsToBounds = true;
            categoryView.layer.cornerRadius = 12;
            categoryView.backgroundColor = BackgroundColor;
            
            //
            
            self.renderCategory(category, categoryView, categoryViewWidth);
            
        }
        
        if (previousViewBottomAnchor != mainScrollView.bottomAnchor){
            previousViewBottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true;
        }
        
    }
    
    internal func renderCategory(_ category: creditCategory, _ categoryView: UIView, _ categoryViewWidth: CGFloat){
        
        let verticalPadding : CGFloat = 5;
        let secondaryVerticalPadding : CGFloat = 2*verticalPadding;
        
        //
        
        let titleLabel = UILabel();
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        categoryView.addSubview(titleLabel);
        
        let titleFontSize : CGFloat = categoryViewWidth * 0.08;
        
        titleLabel.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor).isActive = true;
        titleLabel.topAnchor.constraint(equalTo: categoryView.topAnchor, constant: verticalPadding).isActive = true;
        titleLabel.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor).isActive = true;
        //titleLabel.heightAnchor.constraint(equalToConstant: titleLabelHeight).isActive = true;
        
        titleLabel.text = category.title;
        titleLabel.textAlignment = .center;
        titleLabel.textColor = InverseBackgroundColor;
        titleLabel.font = UIFont(name: SFProDisplay_Bold, size: titleFontSize * 0.8);
        
        //titleLabel.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor).isActive = true;
        
        //
        
        var previousViewBottomAnchor : NSLayoutYAxisAnchor = titleLabel.bottomAnchor;
        
        let personFontSize : CGFloat = categoryViewWidth * 0.05;
        
        for person in category.list{
            
            let personLabel = UITextView();
            
            personLabel.translatesAutoresizingMaskIntoConstraints = false;
            
            categoryView.addSubview(personLabel);
            
            personLabel.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor).isActive = true;
            personLabel.topAnchor.constraint(equalTo: previousViewBottomAnchor, constant:       previousViewBottomAnchor == titleLabel.bottomAnchor ? secondaryVerticalPadding : verticalPadding).isActive = true;
            personLabel.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor).isActive = true;
            
            previousViewBottomAnchor = personLabel.bottomAnchor;
            
            let personAttributedText = NSMutableAttributedString(string: person.name, attributes: [ NSAttributedString.Key.font : UIFont(name: SFProDisplay_Semibold, size: personFontSize)! ]);
            
            if let url = person.url{
                personAttributedText.addAttribute(NSAttributedString.Key.link, value: url, range: NSMakeRange(0, person.name.count));
            }
            
            //personLabel.text = person.name;
            personLabel.attributedText = personAttributedText;
            personLabel.textAlignment = .center;
            personLabel.textColor = InverseBackgroundColor;
            personLabel.isScrollEnabled = false;
            personLabel.backgroundColor = .clear;
            personLabel.isEditable = false;
            personLabel.textContainerInset = .zero;
            //personLabel.font = UIFont(name: SFProDisplay_Regular, size: personFontSize);
            
        }
        
        previousViewBottomAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: -secondaryVerticalPadding).isActive = true;
        
        
    }
    
}
