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
    internal var topCatagoryPickerView : UIButton = UIButton();
    internal var topCatagoryPickerHeightAnchor : NSLayoutConstraint = NSLayoutConstraint();
    
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
        
        //topCatagoryPickerView = UIView(frame: CGRect(x: 0, y: 0, width: mainScrollView.frame.width, height: mainScrollView.frame.height / 10));
        mainScrollView.addSubview(topCatagoryPickerView);
        topCatagoryPickerView.backgroundColor = .systemRed;
        
        // constraints
        topCatagoryPickerView.translatesAutoresizingMaskIntoConstraints = false;
        topCatagoryPickerView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        topCatagoryPickerView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true;
        topCatagoryPickerView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true;
        topCatagoryPickerView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true;
        
        topCatagoryPickerHeightAnchor = topCatagoryPickerView.heightAnchor.constraint(equalToConstant: 100);
        topCatagoryPickerHeightAnchor.isActive = true;
        
        topCatagoryPickerView.addTarget(self, action: #selector(self.test), for: .touchUpInside);
        
        
    }
    
    @objc func test(_ sender: UIButton){
        topCatagoryPickerHeightAnchor.constant += 100;
    }
    
    
}
