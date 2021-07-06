//
//  savedPageActions.swift
//  AHS
//
//  Created by Richard Wei on 7/3/21.
//

import Foundation
import UIKit

extension savedPageViewController : UIScrollViewDelegate{
    
    @objc internal func refresh(_ refreshControl: UIRefreshControl){
        self.renderContent();
        self.refreshControl.endRefreshing();
    }
    
    internal func reload(){
        self.refreshControl.beginRefreshing();
        self.refresh(UIRefreshControl());
    }
    
    @objc internal func clearAll(_ button: UIButton){
        
        for article in dataManager.getSavedArticleList(){
            dataManager.unsaveArticle(article.baseData.articleID);
        }
        
        reload();
    }
    
    @objc internal func sortBy(_ button: UIButton){
        //print("sort by")
        
        if (!sortByPopTip.isVisible){
            
            let sortByViewWidth = mainScrollView.frame.width * 0.3;
            let sortByViewFrame = CGRect(x: 0, y: 0, width: sortByViewWidth, height: sortByViewWidth * 1.2);
            let sortByView = UIView(frame: sortByViewFrame);
            
            sortByView.backgroundColor = InverseBackgroundColor;
            
            sortByPopTip.bubbleColor = BackgroundColor;
            //fontSliderPopTip.isRounded = true;
            sortByPopTip.shouldDismissOnTap = false;
            sortByPopTip.shouldDismissOnSwipeOutside = true;
            sortByPopTip.shouldDismissOnTapOutside = true;
            
            sortByPopTip.show(customView: sortByView, direction: .down, in: mainScrollView, from: CGRect(x: button.center.x, y: button.frame.maxY, width: 0, height: 0));
            
        }
        else{
            sortByPopTip.hide();
        }
        
    }
    
    @objc internal func openArticle(_ button: ArticleButton){
        guard let articledata = button.articleData else{
            return;
        }
        
        let articleDataDict : [String : Any] = ["articleData" : articledata];
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: articlePageNotification), object: nil, userInfo: articleDataDict);
        
    }
    
    //
    
    internal func generateAttributedCategoryString(_ categoryTitle: String, _ height: CGFloat) -> NSAttributedString{
        
        let fontSize = height * 0.7;
        
        let attributedString = NSMutableAttributedString(string: categoryTitle, attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: fontSize)!]);
        attributedString.append(NSAttributedString(string: " Section", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Regular, size: fontSize)!]));
        
        return attributedString;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        sortByPopTip.hide();
    }
    
}
