//
//  spotlightPageViewControllerActions.swift
//  AHS
//
//  Created by Richard Wei on 6/4/21.
//

import Foundation
import UIKit

extension spotlightPageViewController{
    
    @objc internal func dismissHandler(_ button: UIButton){
        self.dismiss(animated: true);
    }
    
    @objc internal func handleRefresh(){
        refreshControl.beginRefreshing();
        renderContent();
    }
    
    @objc internal func openArticle(_ button: ArticleButton){
    
        let vc = articlePageViewController();
        
        vc.articleID = button.articleID;
        
        transitionDelegateVar = transitionDelegate();
        vc.transitioningDelegate = transitionDelegateVar;
        vc.modalPresentationStyle = .custom;
        
        self.present(vc, animated: true);
        
    }
}
