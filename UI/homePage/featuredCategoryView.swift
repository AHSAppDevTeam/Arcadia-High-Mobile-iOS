//
//  featuredCategoryView.swift
//  AHS
//
//  Created by Richard Wei on 3/30/21.
//

import Foundation
import UIKit

class featuredCategoryViewController : homeContentPageViewController{
    override func viewDidLoad() {
        super.viewDidLoad();
        NotificationCenter.default.addObserver(self, selector: #selector(self.reload), name: NSNotification.Name(rawValue: homePageRefreshNotification), object: nil);
        load();
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: homePageRefreshNotification), object: nil);
    }
    
    internal func load(){
        dataManager.getFeaturedCategoryData(completion: { (data) in
            self.renderView(data: data);
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: homePageEndRefreshing), object: nil);
        });
    }
    
    @objc func reload(_ notification: NSNotification){
        for view in self.view.subviews{
            view.removeFromSuperview();
        }
        updateParentHeightConstraint();
        load();
    }
    
    internal func renderView(data: featuredCategoryData){
        
        let outerHorizontalPadding = homePageHorizontalPadding;
        let mainViewWidth = AppUtility.getCurrentScreenSize().width - 2*outerHorizontalPadding;
        
        let horizontalPadding = CGFloat(25);
        let verticalPadding = CGFloat(5);
        
        let titleLabelText = data.title;
        let titleLabelFont = UIFont(name: SFProDisplay_Bold, size: 20)!;
        let titleLabelWidth = mainViewWidth - 2*horizontalPadding;
        let titleLabelHeight = titleLabelText.height(withConstrainedWidth: titleLabelWidth, font: titleLabelFont);
        
        let bodyLabelText = data.blurb;
        let bodyLabelFont = UIFont(name: SFProDisplay_Regular, size: 15)!;
        let bodyLabelWidth = mainViewWidth - 2*horizontalPadding;
        let bodyLabelHeight = bodyLabelText.height(withConstrainedWidth: bodyLabelWidth, font: bodyLabelFont);
        
        let mainViewHeight = titleLabelHeight + bodyLabelHeight + 2*verticalPadding;
        
        let mainViewFrame = CGRect(x: outerHorizontalPadding, y: 0, width: mainViewWidth, height: mainViewHeight);
        let mainView = UIButton(frame: mainViewFrame);
        
        mainView.layer.cornerRadius = 25;
        mainView.backgroundColor = UIColor {_ in
            return UIColor.dynamicColor(light: data.colorLightMode, dark: data.colorDarkMode);
        }
        
        mainView.addTarget(self, action: #selector(self.handlePress), for: .touchUpInside);
        
        self.view.addSubview(mainView);
        
        let titleLabel = UILabel(frame: CGRect(x: horizontalPadding, y: verticalPadding, width: titleLabelWidth, height: titleLabelHeight));
        titleLabel.text = titleLabelText;
        titleLabel.font = titleLabelFont;
        titleLabel.textColor = BackgroundColor;
        titleLabel.numberOfLines = 0;
        
        mainView.addSubview(titleLabel);
        
        let bodyLabel = UILabel(frame: CGRect(x: horizontalPadding, y: titleLabel.frame.maxY, width: bodyLabelWidth, height: bodyLabelHeight));
        bodyLabel.text = bodyLabelText;
        bodyLabel.font = bodyLabelFont;
        bodyLabel.textColor = BackgroundColor;
        bodyLabel.numberOfLines = 0;
        
        mainView.addSubview(bodyLabel);
        
        // chevron.right
        
        let chevronImageViewFrame = CGRect(x: mainView.frame.width - horizontalPadding - 5, y: 0, width: horizontalPadding, height: mainView.frame.height);
        let chevronImageView = UIImageView(frame: chevronImageViewFrame);
        
        chevronImageView.image = UIImage(systemName: "chevron.right");
        chevronImageView.contentMode = .scaleAspectFit;
        chevronImageView.tintColor = BackgroundColor;
        
        mainView.addSubview(chevronImageView);
        
        updateParentHeightConstraint();
    }
    
    override func updateParentHeightConstraint(){
        let parentVC = self.parent as! homePageViewController;
        parentVC.featuredCategoryViewHeightAnchor.constant = self.getSubviewsMaxY();
    }
    
    @objc func handlePress(_ sender: UIButton){
        print("featured category press");
        //self.reload();
    }
}
