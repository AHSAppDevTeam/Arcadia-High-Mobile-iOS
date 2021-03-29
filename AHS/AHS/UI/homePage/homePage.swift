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
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if (!self.hasBeenSetup){
            self.view.backgroundColor = BackgroundColor;
            
            mainScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height));
            mainScrollView.backgroundColor = .systemBlue;
            
            self.view.addSubview(mainScrollView);
            
            setupTopCatagoryPickerView();
            
            
            self.hasBeenSetup = true;
        }
        
    }
    
    private func setupTopCatagoryPickerView(){
        
        //top category
        mainScrollView.addSubview(topCatagoryPickerView);
        topCatagoryPickerView.backgroundColor = .systemRed;
        
        // constraints
        topCatagoryPickerView.translatesAutoresizingMaskIntoConstraints = false;
        topCatagoryPickerView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        topCatagoryPickerView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true;
        topCatagoryPickerView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true;
        //topCatagoryPickerView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true;
        
        topCatagoryPickerViewHeightAnchor = topCatagoryPickerView.heightAnchor.constraint(equalToConstant: 100);
        topCatagoryPickerViewHeightAnchor.isActive = true;
        
        //
        
        mainScrollView.addSubview(featuredCategoryView);
        featuredCategoryView.backgroundColor = .systemGreen;
        
        featuredCategoryView.translatesAutoresizingMaskIntoConstraints = false;
        featuredCategoryView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        featuredCategoryView.topAnchor.constraint(equalTo: topCatagoryPickerView.bottomAnchor).isActive = true;
        featuredCategoryView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true;
        
        featuredCategoryViewHeightAnchor = featuredCategoryView.heightAnchor.constraint(equalToConstant: 100);
        featuredCategoryViewHeightAnchor.isActive = true;
        
        //
        
        mainScrollView.addSubview(contentView);
        contentView.backgroundColor = .systemOrange;
        
        contentView.translatesAutoresizingMaskIntoConstraints = false;
        contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        contentView.topAnchor.constraint(equalTo: featuredCategoryView.bottomAnchor).isActive = true;
        contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true;
        contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true;
        
        contentViewHeightAnchor = contentView.heightAnchor.constraint(equalToConstant: 500);
        contentViewHeightAnchor.isActive = true;
    }
    
    
}
