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
            //topBarHomeView.isHidden = false;
            //topBarTitleLabel.isHidden = true;
            
            let month = "September"; // placeholder rn
            let date = "88"; // placeholder rn
            
            // set content
            
            let attributedText = NSMutableAttributedString(string: "Arcadia", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: topBarView.frame.height * 0.39)]);
            
            attributedText.append(NSAttributedString(string: "\n\(month)", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Medium, size: topBarView.frame.height * 0.3)]));
            
            attributedText.append(NSAttributedString(string: " \(date)", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Light, size: topBarView.frame.height * 0.3)]));
            
            topBarTitleLabel.attributedText = attributedText;
            
        }
        else{
            //topBarHomeView.isHidden = true;
            //topBarTitleLabel.isHidden = false;
            
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
        let vc = contentViewControllers[selectedButtonIndex];
        vc.willMove(toParent: self);
        addChild(vc);
        vc.view.frame = contentView.bounds;
        contentView.addSubview(vc.view);
        vc.didMove(toParent: self);
        
    }
}
