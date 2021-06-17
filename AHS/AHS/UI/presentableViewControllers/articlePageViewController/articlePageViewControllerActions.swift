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
            let popupView = UIView(frame: CGRect(x: 0, y: 0, width: popupViewWidth, height: popupViewWidth * 0.11));
            
            let popupViewContentHorizontalPadding : CGFloat = 5;
            
            popupView.backgroundColor = BackgroundColor;
            
            //
            
            fontLabel = UILabel();
            popupView.addSubview(fontLabel);
            
            fontLabel.translatesAutoresizingMaskIntoConstraints = false;
            fontLabel.topAnchor.constraint(equalTo: popupView.topAnchor).isActive = true;
            fontLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -popupViewContentHorizontalPadding).isActive = true;
            fontLabel.bottomAnchor.constraint(equalTo: popupView.bottomAnchor).isActive = true;
            
            fontLabel.textAlignment = .center;
            fontLabel.font = UIFont(name: SFProDisplay_Regular, size: popupView.frame.height * 0.8);
            fontLabel.textColor = InverseBackgroundColor;
            fontLabel.text = String(dataManager.preferencesStruct.fontSize);
            
            //
            
            let fontSliderView = UISlider();
            popupView.addSubview(fontSliderView);
            
            fontSliderView.translatesAutoresizingMaskIntoConstraints = false;
            fontSliderView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true;
            fontSliderView.topAnchor.constraint(equalTo: popupView.topAnchor).isActive = true;
            fontSliderView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor).isActive = true;
            fontSliderView.trailingAnchor.constraint(equalTo: fontLabel.leadingAnchor, constant: -popupViewContentHorizontalPadding).isActive = true;
            
            fontSliderView.maximumValue = 50;
            fontSliderView.minimumValue = 1;
            
            fontSliderView.value = Float(dataManager.preferencesStruct.fontSize);
            
            fontSliderView.addTarget(self, action: #selector(self.fontSliderValueChanged), for: .valueChanged);
            
            //
            
            fontSliderPopTip.bubbleColor = BackgroundColor;
            //fontSliderPopTip.isRounded = true;
            fontSliderPopTip.shouldDismissOnTap = false;
            fontSliderPopTip.shouldDismissOnSwipeOutside = true;
            fontSliderPopTip.shouldDismissOnTapOutside = true;
            
            fontSliderPopTip.show(customView: popupView, direction: .down, in: self.view, from: CGRect(x: button.center.x, y: topBarView.frame.maxY, width: 0, height: 0));
            
        }
        else{
            fontSliderPopTip.hide();
        }
        
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        fontSliderPopTip.hide();
    }
    
    @objc internal func fontSliderValueChanged(_ slider: UISlider){
        //print(slider.value);
        let fontSize = Int(slider.value);
        fontLabel.text = String(fontSize);
        dataManager.preferencesStruct.fontSize = fontSize;
    }
    
}
