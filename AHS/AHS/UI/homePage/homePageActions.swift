//
//  homePageActions.swift
//  AHS
//
//  Created by Richard Wei on 3/27/21.
//

import Foundation
import UIKit

extension homePageViewController{
    
    @objc func refresh(_ sender: UIRefreshControl){
        //print("refresh");
        //refreshControl.endRefreshing();
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: homePageRefreshNotification), object: nil);
    }
    
    @objc func endRefreshing(_ notification: NSNotification){
        refreshControl.endRefreshing();
    }
    
    @objc func beginRefreshing(_ notification: NSNotification){
        refreshControl.beginRefreshing();
    }
    
    @objc func selectCategoryButton(_ sender: UIButton){
        let tag = sender.tag;
        
        for i in 0..<topCategoryPickerButtons.count{
            
            let button = topCategoryPickerButtons[i];
            let buttonColor = topCategoryPickerButtonColors[i];
            
            if (i != tag){ // non selected
                
                button.backgroundColor = BackgroundColor;
                
                if (i == 2){ // is search button
                    button.tintColor = buttonColor;
                }
                else{
                    button.setTitleColor(buttonColor, for: .normal);
                }
                
            }
            else{ // selected button
                button.backgroundColor = buttonColor;
                
                if (i == 2){ // is search button
                    button.tintColor = BackgroundColor;
                }
                else{
                    button.setTitleColor(BackgroundColor, for: .normal);
                }
                
            }
            
        }
        
        
        setContentView(tag);
        
    }
    
    internal func setContentView(_ index: Int){
        
        //for view in contentView
        //let newscontent : newsPageController = contentViewControllers[0] as! newsPageController;
        //let communitycontent : communityPageController = contentViewControllers[1] as! communityPageController;
        
        if (index != contentViewControllerIndex){
            
            if (contentViewControllerIndex != -1){ // we must remove the prev view controller
                
                for view in contentView.subviews{
                    view.removeFromSuperview();
                }
                
                let vc = contentViewControllers[contentViewControllerIndex];
                
                vc.willMove(toParent: nil);
                vc.view.removeFromSuperview();
                vc.removeFromParent();
                
            }
            
            let vc = contentViewControllers[index];
            
            vc.willMove(toParent: self);
            vc.view.frame = contentView.bounds;
            contentView.addSubview(vc.view);
            self.addChild(vc);
            vc.didMove(toParent: self);
            
            contentViewHeightAnchor.constant = vc.getSubviewsMaxY();
            
            contentViewControllerIndex = index;
            
        }
    }
    
}
