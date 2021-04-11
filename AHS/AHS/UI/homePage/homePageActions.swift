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
    
    @objc func selectCategoryButton(_ sender: UIButton){
        let tag = sender.tag;
        
        if (tag == 1){
            newsButton.backgroundColor = newsButtonColor;
            newsButton.setTitleColor(BackgroundColor, for: .normal);
            
            communityButton.backgroundColor = BackgroundColor;
            communityButton.setTitleColor(communityButtonColor, for: .normal);
        
            setContentView(0);
        }
        else if (tag == 2){
            newsButton.backgroundColor = BackgroundColor;
            newsButton.setTitleColor(newsButtonColor, for: .normal);
            
            communityButton.backgroundColor = communityButtonColor;
            communityButton.setTitleColor(BackgroundColor, for: .normal);
            
            setContentView(1);
        }
        
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
