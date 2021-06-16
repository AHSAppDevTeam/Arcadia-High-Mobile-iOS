//
//  articlePageViewControllerActions.swift
//  AHS
//
//  Created by Richard Wei on 5/28/21.
//

import Foundation
import UIKit
import AMPopTip

extension articlePageViewController{
    @objc internal func handleRefresh(){
        
        for subview in scrollView.subviews{
            if (subview.tag == 1){
                subview.removeFromSuperview();
            }
        }
        
        nextContentY = 0;
        
        loadArticleData();
    }
    
    @objc internal func handleBackButton(_ button: UIButton){
        self.dismiss(animated: true);
    }
    
    @objc internal func toggleUserInterface(_ button: UIButton){
        
        if (userInterfaceStyle == .unspecified){
            userInterfaceStyle = UIScreen.main.traitCollection.userInterfaceStyle;
        }
        
        if (userInterfaceStyle == .light){
            userInterfaceStyle = .dark;
        }
        else{
            userInterfaceStyle = .light;
        }
        
        self.overrideUserInterfaceStyle = userInterfaceStyle;
        AppUtility.currentUserInterfaceStyle = userInterfaceStyle;
        
        self.setNeedsStatusBarAppearanceUpdate();
        
    }
    
    @objc internal func toggleBookmark(_ button: UIButton){
        
        button.isSelected = !button.isSelected;
        
        if (button.isSelected){
            button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal);
        }
        else{
            button.setImage(UIImage(systemName: "bookmark"), for: .normal);
        }
        
    }
    
    @objc internal func openRelatedArticle(_ button: ArticleButton){
        
        let articlePageVC = articlePageViewController();
        
        articlePageVC.articleID = button.articleID;
        
        openChildPage(articlePageVC);
    }
    
    @objc internal func openCategoryPage(_ button: CategoryButton){
        
        let categoryPageVC = spotlightPageViewController();
        
        categoryPageVC.categoryID = button.categoryID;
        
        openChildPage(categoryPageVC);
        
    }
    
    @objc internal func openChildPage(_ vc: presentableViewController){
        
        transitionDelegateVar = transitionDelegate();
        vc.transitioningDelegate = transitionDelegateVar;
        vc.modalPresentationStyle = .custom;
        
        self.present(vc, animated: true);
        
    }
    
    @objc internal func showFontPopup(_ button: UIButton){
        
        if (!fontSliderPopTip.isVisible){
            
            let popupViewWidth = self.view.frame.width * 0.6;
            let popupView = UIView(frame: CGRect(x: 0, y: 0, width: popupViewWidth, height: popupViewWidth * 0.1));
            
            popupView.backgroundColor = BackgroundColor;
            
            //
            
            fontSliderPopTip.bubbleColor = BackgroundColor;
            
            fontSliderPopTip.show(customView: popupView, direction: .down, in: topBarView, from: button.frame);
            
        }
        else{
            fontSliderPopTip.hide();
        }
        
    }
    
    @objc internal func tappedAroundHandler(_ sender: UITapGestureRecognizer){
        fontSliderPopTip.hide();
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        fontSliderPopTip.hide();
    }
    
}
