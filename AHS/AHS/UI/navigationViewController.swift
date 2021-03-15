//
//  navigationViewController.swift
//  AHS
//
//  Created by Richard Wei on 3/13/21.
//

import Foundation
import UIKit

class navigationViewController : UIViewController{
    
    // Content View
    private var contentView : UIView = UIView();
    
    // Navigation Bar View
    private let buttonArraySize = 4;
    private var buttonViewArray : [UIButton] = Array(repeating: UIButton(), count: 4);
    private var navigationBarView : UIView = UIView();
    
    private var selectedButtonIndex : Int = 0;
    
    // Top Bar View
    private var topBarView : UIView = UIView();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor = BackgroundColor;
        
        renderNavigationBar();
        renderTopBar();
        
        // setup content view now
        contentView = UIView(frame: CGRect(x: 0, y: topBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - topBarView.frame.maxY - navigationBarView.frame.height));
        self.view.addSubview(contentView);
        
        //contentView.backgroundColor = .systemGreen;
        
    }
    
    private func renderNavigationBar(){
        
        let navigationBarViewHeight = CGFloat(1/10 * self.view.frame.height);
        let navigationBarViewFrame = CGRect(x: 0, y: self.view.frame.height - navigationBarViewHeight, width: self.view.frame.width, height: navigationBarViewHeight);
        navigationBarView = UIView(frame: navigationBarViewFrame);
        
        navigationBarView.backgroundColor = dull_BackgroundColor;
        
        self.view.addSubview(navigationBarView);
        
        //
        
        let buttonStackFrame = CGRect(x: 0, y: 0, width: navigationBarView.frame.width, height: navigationBarView.frame.height - AppUtility.safeAreaInset.bottom);
        let buttonStackView = UIStackView(frame: buttonStackFrame);
        
        buttonStackView.alignment = .center;
        buttonStackView.axis = .horizontal;
        buttonStackView.distribution = .fillEqually;
        
        for i in 0..<4{
            let button = UIButton();
            
            button.setImage(UIImage(named: "icon_no_bg"), for: .normal);
            button.imageView?.contentMode = .scaleAspectFit;
            button.addTarget(self, action: #selector(changePage), for: .touchUpInside);
            button.contentVerticalAlignment = .center;
            button.tag = i;
            
            button.heightAnchor.constraint(equalToConstant: buttonStackView.frame.height * 2/3).isActive = true;
            
            buttonStackView.addArrangedSubview(button);
        }

        navigationBarView.addSubview(buttonStackView);
        
    }
    
    private func renderTopBar(){
        
        let topBarViewHeight = CGFloat(1/13 * self.view.frame.height);
        let topBarViewFrame = CGRect(x: 0, y: AppUtility.safeAreaInset.top, width: self.view.frame.width, height: topBarViewHeight);
        topBarView = UIView(frame: topBarViewFrame);
        
        topBarView.backgroundColor = .blue;
        
        self.view.addSubview(topBarView);
        
    }
    
    @objc func changePage(_ button: UIButton){
        print("button press id \(button.tag)");
        selectedButtonIndex = button.tag;
    }
    
}
