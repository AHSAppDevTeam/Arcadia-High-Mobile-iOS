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
    
    private let contentViewControllers : [UIViewController] = [homePageViewController(), bulletinPageViewController(), savedPageViewController(), profilePageViewController()];
    
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
        
        // setup content view
        contentView = UIView(frame: CGRect(x: 0, y: topBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - topBarView.frame.maxY - navigationBarView.frame.height));
        self.view.addSubview(contentView);
        
        // setup top bar
        
        selectButton(buttonViewArray[selectedButtonIndex]);
        updateTopBar(selectedButtonIndex); // should be 0
       
        // update content view with default page
        
        let vc = contentViewControllers[selectedButtonIndex];
        addChild(vc);
        vc.view.frame = contentView.bounds;
        contentView.addSubview(vc.view);
        vc.didMove(toParent: self);
        
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
            
            buttonViewArray[i] = button;
            
            buttonStackView.addArrangedSubview(button);
        }

        navigationBarView.addSubview(buttonStackView);
        
    }
    
    private func renderTopBar(){
        
        let topBarViewHeight = CGFloat(1/13 * self.view.frame.height);
        let topBarViewFrame = CGRect(x: 0, y: AppUtility.safeAreaInset.top, width: self.view.frame.width, height: topBarViewHeight);
        topBarView = UIView(frame: topBarViewFrame);
        
        self.view.addSubview(topBarView);
        
    }
    
    // After setup functions
    
    @objc func changePage(_ sender: UIButton){
        //print("button press id \(sender.tag)");
        let prevIndex = selectedButtonIndex;
        selectedButtonIndex = sender.tag;
        
        selectButton(sender);
        unselectButton(buttonViewArray[prevIndex]);
        
        updateTopBar(selectedButtonIndex);
        updateContentView(selectedButtonIndex, prevIndex);
        
    }
    
    private func selectButton(_ button: UIButton){
        button.isSelected = true;
    }
    
    private func unselectButton(_ button: UIButton){
        button.isSelected = false;
    }
    
    private func updateTopBar(_ pageIndex: Int){
        
    }
    
    private func updateContentView(_ pageIndex: Int, _ prevIndex: Int){
        
        // remove prev view controller
        let prevVC = contentViewControllers[prevIndex];
        prevVC.willMove(toParent: nil);
        prevVC.view.removeFromSuperview();
        prevVC.removeFromParent();
        
        // add new view controller
        let vc = contentViewControllers[selectedButtonIndex];
        vc.willMove(toParent: self);
        addChild(vc);
        vc.view.frame = contentView.bounds;
        contentView.addSubview(vc.view);
        vc.didMove(toParent: self);
        
    }
    
}
