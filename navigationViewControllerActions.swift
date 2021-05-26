//
//  navigationViewControllerActions.swift
//  AHS
//
//  Created by Richard Wei on 3/15/21.
//

import Foundation
import UIKit

extension navigationViewController{
    // After setup functions
    
    @objc func changePage(_ sender: UIButton){
        //print("button press id \(sender.tag)");
        if (sender.tag != selectedButtonIndex){
            let prevIndex = selectedButtonIndex;
            selectedButtonIndex = sender.tag;
            
            selectButton(sender);
            unselectButton(buttonViewArray[prevIndex]);
            
            updateTopBar(selectedButtonIndex);
            updateContentView(selectedButtonIndex, prevIndex);
        }
        else{ // same button was pressed multiple times so send out notification to viewcontrollers to update scrollviews
            
        }
    }
    
    @objc func openNotificationPage(_ sender: UIButton){
        print("open notifications page");
    }
    
    internal func selectButton(_ button: UIButton){
        button.isSelected = true;
        button.tintColor = NavigationButtonSelectedColor;
    }
    
    internal func unselectButton(_ button: UIButton){
        button.isSelected = false;
        button.tintColor = NavigationButtonUnselectedColor;
    }
    
    internal func updateTopBar(_ pageIndex: Int){
        if (pageIndex == 0){ // show home
            topBarHomeView.isHidden = false;
            topBarTitleLabel.isHidden = true;            
        }
        else{
            topBarHomeView.isHidden = true;
            topBarTitleLabel.isHidden = false;
            
            topBarTitleLabel.attributedText = createAttributedTitleString(pageIndex);
            topBarTitleLabel.centerTextVertically();
        }
        
        topBarTitleLabel.textColor = mainThemeColor;
        
    }
    
    private func createAttributedTitleString(_ pageIndex: Int) -> NSMutableAttributedString{
        
        //print("create string called - \(pageIndex) = \(contentViewControllers[pageIndex].pageName) \(contentViewControllers[pageIndex].secondaryPageName) ")
        
        // ignore warnings
        
        let attributedText = NSMutableAttributedString(string: contentViewControllers[pageIndex].pageName, attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: topBarView.frame.height * 0.5)]);
        
        attributedText.append(NSAttributedString(string: " " + contentViewControllers[pageIndex].secondaryPageName, attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Regular, size: topBarView.frame.height * 0.5)]));
        
        return attributedText;
    }
    
    internal func updateContentView(_ pageIndex: Int, _ prevIndex: Int){
        
        // remove prev view controller
        let prevVC = contentViewControllers[prevIndex];
        prevVC.willMove(toParent: nil);
        prevVC.view.removeFromSuperview();
        prevVC.removeFromParent();
        
        // add new view controller
        
        
        //if the selectedButtonIndex is 3 (which is the number for the profile page), then it presents the navigationController for the profile page and not the profile page itself
        if selectedButtonIndex == 3
        {
            let vc = profilePageNavigationController;
            vc.willMove(toParent: self);
            addChild(vc);
            vc.view.frame = contentView.bounds;
            contentView.addSubview(vc.view);
            vc.didMove(toParent: self);
            profilePageNavigationController.navigationBar.backgroundColor = .clear
            profilePageNavigationController.navigationBar.isTranslucent = false
            profilePageNavigationController.navigationBar.shadowImage = UIImage()
            

            
        }
        else {
            let vc = contentViewControllers[selectedButtonIndex];
            vc.willMove(toParent: self);
            addChild(vc);
            vc.view.frame = contentView.bounds;
            contentView.addSubview(vc.view);
            vc.didMove(toParent: self);
            print("okok")
            print(selectedButtonIndex)
        }
        
    }
}
