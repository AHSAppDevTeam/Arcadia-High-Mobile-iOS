//
//  navigationViewController.swift
//  AHS
//
//  Created by Richard Wei on 3/13/21.
//

import Foundation
import UIKit

class navigationViewController : UIViewController{
    
    // Safe Area View
    private var safeAreaView : UIView = UIView();
    
    // Content View
    private var contentView : UIView = UIView();
    
    // Navigation Bar View
    private let buttonArraySize = 4;
    private var buttonViewArray : [UIButton] = Array(repeating: UIButton(), count: 4);
    private var selectedButtonIndex : UInt = 0;
    private var navigationBarView : UIView = UIView();
    
    // Top Bar View
    private var topBarView : UIView = UIView();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        setupSafeAreaView();
        
        renderNavigationBar();
        renderTopBar();
        
        // setup content view now
        contentView = UIView(frame: CGRect(x: 0, y: topBarView.frame.height, width: safeAreaView.frame.width, height: safeAreaView.frame.height - topBarView.frame.height - navigationBarView.frame.height));
        safeAreaView.addSubview(contentView);
        
        contentView.backgroundColor = .green;
        
    }
    
    private func setupSafeAreaView(){
        let safeAreaFrame = CGRect(x: 0, y: AppUtility.safeAreaInset.top, width: AppUtility.getCurrentScreenSize().width, height: AppUtility.getCurrentScreenSize().height - AppUtility.safeAreaInset.top - AppUtility.safeAreaInset.bottom);
        safeAreaView = UIView(frame: safeAreaFrame);
        self.view.addSubview(safeAreaView);
    }
    
    private func renderNavigationBar(){
        
        let navigationBarViewHeight = CGFloat(1/15 * safeAreaView.frame.height);
        let navigationBarViewFrame = CGRect(x: 0, y: safeAreaView.frame.height - navigationBarViewHeight, width: safeAreaView.frame.width, height: navigationBarViewHeight);
        navigationBarView = UIView(frame: navigationBarViewFrame);
        
        safeAreaView.addSubview(navigationBarView);
        
        let buttonStackFrame = CGRect(x: 0, y: 0, width: navigationBarView.frame.width, height: navigationBarView.frame.height);
        let buttonStackView = UIStackView(frame: buttonStackFrame);
        
        buttonStackView.alignment = .center;
        buttonStackView.axis = .horizontal;
        buttonStackView.distribution = .fillEqually;
        
        let colors : [UIColor] = [.blue, .brown, .black, .green];
        for i in 0...3{
            let button = UIButton();
            
            button.backgroundColor = colors[i];
            
            buttonStackView.addArrangedSubview(button);
        }
        
        buttonStackView.backgroundColor = .cyan;
        
        navigationBarView.addSubview(buttonStackView);
        
    }
    
    private func renderTopBar(){
        
        let topBarViewHeight = CGFloat(1/10 * safeAreaView.frame.height);
        let topBarViewFrame = CGRect(x: 0, y: 0, width: safeAreaView.frame.width, height: topBarViewHeight);
        topBarView = UIView(frame: topBarViewFrame);
        
        topBarView.backgroundColor = .blue;
        
        safeAreaView.addSubview(topBarView);
        
    }
    
}
