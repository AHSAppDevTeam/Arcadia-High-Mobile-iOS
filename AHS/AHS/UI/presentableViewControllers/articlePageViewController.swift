//
//  articlePageViewController.swift
//  AHS
//
//  Created by Richard Wei on 5/25/21.
//

import Foundation
import UIKit


class articlePageViewController : presentableViewController{
    
    public var articleID : String = "";
    internal var nextContentY : CGFloat = 0;
    
    let scrollView : UIScrollView = UIScrollView();
    let refreshControl : UIRefreshControl = UIRefreshControl();
    
    override func viewDidLoad() {
        super.viewDidLoad();
    
        renderUI();
        loadArticleData();
    }
    
    internal func renderUI(){
        
        self.view.backgroundColor = BackgroundColor;
        setupPanGesture();
        
        //
        
        let topBarViewFrame = CGRect(x: 0, y: AppUtility.safeAreaInset.top, width: self.view.frame.width, height: self.view.frame.width * 0.15);
        let topBarView = UIView(frame: topBarViewFrame);
        
        topBarView.backgroundColor = .systemPink;
        
        self.view.addSubview(topBarView);
        
        //
        
        scrollView.frame = CGRect(x: 0, y: topBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - topBarView.frame.maxY);
        self.view.addSubview(scrollView);
        
        //scrollView.backgroundColor = InverseBackgroundColor;
        scrollView.alwaysBounceVertical = true;
        
        refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: .valueChanged)
        scrollView.addSubview(refreshControl);
        
    }
    
    @objc internal func handleRefresh(){
        
        for subview in scrollView.subviews{
            if (subview.tag == 1){
                subview.removeFromSuperview();
            }
        }
        
        loadArticleData();
    }
    
    internal func loadArticleData(){
        dataManager.getFullArticleData(articleID, completion: { (data) in
            self.renderArticle(data);
        });
    }
    
    internal func renderArticle(_ articleData: fullArticleData){
        
    }
    
}
