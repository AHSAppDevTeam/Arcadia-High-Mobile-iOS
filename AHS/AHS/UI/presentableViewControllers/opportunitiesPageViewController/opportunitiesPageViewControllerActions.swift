//
//  opportunitiesPageViewControllerActions.swift
//  AHS
//
//  Created by Kaitlyn Kwan on 2/5/23.
//

import Foundation
import UIKit

extension opportunitiesPageViewController{
    
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
