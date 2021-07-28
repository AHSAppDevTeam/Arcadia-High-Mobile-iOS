//
//  savedPageActions.swift
//  AHS
//
//  Created by Richard Wei on 7/3/21.
//

import Foundation
import UIKit
import AudioToolbox

extension savedPageViewController : UIScrollViewDelegate{
    
    @objc internal func refresh(){
        self.renderContent();
        self.refreshControl.endRefreshing();
    }
    
    internal func reload(){
        self.refreshControl.beginRefreshing();
        self.refresh();
    }
    
    @objc internal func endRefreshing(){
        self.refreshControl.endRefreshing();
        self.mainScrollView.setContentOffset(.zero, animated: true);
    }
    
    @objc internal func resetContentOffset(){
        self.mainScrollView.setContentOffset(.zero, animated: true);
    }
    
    @objc internal func clearAll(_ button: UIButton){
        
        createConfirmationPrompt(self, "Clear All Saved Articles", confirmCompletion: { () in
            UIImpactFeedbackGenerator(style: .light).impactOccurred();
            
            for article in dataManager.getSavedArticleList(){
                dataManager.unsaveArticle(article.baseData.articleID);
            }
            
            self.reload();
        });
        
    }
    
    @objc internal func sortBy(_ button: UIButton){
        //print("sort by")
        
        if (!sortByPopTip.isVisible){
            
            let sortByTableViewWidth = mainScrollView.frame.width * 0.35;
            let sortByTableViewCellHeight = sortByTableViewWidth * 0.22;
            let sortByTableViewHeight = sortByTableViewCellHeight * CGFloat(savedSortingStruct.numberOfCells());
            
            let sortByTableViewFrame = CGRect(x: 0, y: 0, width: sortByTableViewWidth, height: sortByTableViewHeight);
            let sortByTableView = UITableView(frame: sortByTableViewFrame);
            
            cellHeight = sortByTableViewCellHeight;
            
            sortByTableView.delegate = self;
            sortByTableView.dataSource = self;
            sortByTableView.rowHeight = sortByTableViewCellHeight;
            sortByTableView.isScrollEnabled = false;
            sortByTableView.register(savedPageSortByCell.self, forCellReuseIdentifier: savedPageSortByCell.identifier);
            
            //
            
            sortByPopTip.bubbleColor = BackgroundColor;
            //fontSliderPopTip.isRounded = true;
            sortByPopTip.shouldDismissOnTap = false;
            sortByPopTip.shouldDismissOnSwipeOutside = true;
            sortByPopTip.shouldDismissOnTapOutside = true;
            
            sortByPopTip.show(customView: sortByTableView, direction: .down, in: mainScrollView, from: CGRect(x: button.center.x, y: button.frame.maxY, width: 0, height: 0));
            
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
