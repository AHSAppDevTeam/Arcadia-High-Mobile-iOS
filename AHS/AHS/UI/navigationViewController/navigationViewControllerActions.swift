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
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: setScrollViewZeroContentOffset), object: nil);
        }
    }
    
    @objc func openArticlePage(_ notification: NSNotification){
        guard let dict = notification.userInfo as NSDictionary? else{
            return;
        }
        
        let vc = articlePageViewController();
        
        if let articledata = dict["articleData"] as? fullArticleData{
            vc.articledata = articledata;
        }
        else{
            guard let articleID = dict["articleID"] as? String else{
                return;
            }
            
            vc.articleID = articleID;
        }
        
        openPresentablePage(vc);
    }

    @objc func openNotificationPage(){
        openPresentablePage(notificationPageViewController());
    }
    
    @objc func openCategoryPage(_ notification: NSNotification){
        guard let dict = notification.userInfo as NSDictionary? else{
            return;
        }
        guard let categoryID = dict["categoryID"] as? String else{
            return;
        }
        
        let vc = spotlightPageViewController();
        
        vc.categoryID = categoryID;
        
        openPresentablePage(vc);
        
    }
    
    @objc func openProfileContentPage(_ notification: NSNotification){
        
        guard let dict = notification.userInfo as NSDictionary? else{
            return;
        }
        
        guard let vc = dict["vc"] as? presentableViewController else{
            return;
        }
        
        openPresentablePage(vc);
    }
    
    @objc func openSearchPage(_ notification: NSNotification){
        //let vc = searchPageViewController();
        //openPresentablePage(vc);
        presentSearchPage();
        updateTopBar(searchPageContentViewControllerIndex);
    }
    
    internal func openPresentablePage(_ vc: presentableViewController){
        transitionDelegateVar = transitionDelegate();
        vc.transitioningDelegate = transitionDelegateVar;
        vc.modalPresentationStyle = .custom;
        
        self.present(vc, animated: true);
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
        
        let pageNameString = pageIndex < contentViewControllers.count  ? contentViewControllers[pageIndex].pageName : (pageIndex == searchPageContentViewControllerIndex ? searchPageContentViewController.pageName : "ERROR");
        let secondaryPageNameString = pageIndex < contentViewControllers.count ? contentViewControllers[pageIndex].secondaryPageName : (pageIndex == searchPageContentViewControllerIndex ? searchPageContentViewController.secondaryPageName : "ERROR");
        
        let attributedText = NSMutableAttributedString(string: pageNameString, attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: topBarView.frame.height * 0.5)]);
        
        attributedText.append(NSAttributedString(string: " " + secondaryPageNameString, attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Regular, size: topBarView.frame.height * 0.5)]));
        
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
    
    internal func presentSearchPage(){
        let vc = searchPageContentViewController;
        vc.willMove(toParent: self);
        addChild(vc);
        vc.view.frame = contentView.bounds;
        contentView.addSubview(vc.view);
        vc.didMove(toParent: self);
    }
    
}
