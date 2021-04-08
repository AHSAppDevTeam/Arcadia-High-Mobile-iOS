//
//  newsPage_featured.swift
//  AHS
//
//  Created by Richard Wei on 4/7/21.
//

import Foundation
import UIKit

extension newsPageController{
    
    internal func renderFeatured(){
        
        let featuredLabelFrame = CGRect(x: 0, y: nextY, width: AppUtility.getCurrentScreenSize().width, height: AppUtility.getCurrentScreenSize().width / 10);
        let featuredLabel = UITextView(frame: featuredLabelFrame);
        
        featuredLabel.isUserInteractionEnabled = false;
        featuredLabel.isEditable = false;
        featuredLabel.isSelectable = false;
        featuredLabel.textAlignment = .left;
        
        let featuredLabelText = NSMutableAttributedString(string: "Featured", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: featuredLabel.frame.height * 0.7)!]);
        featuredLabelText.append(NSAttributedString(string: " Articles", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Light, size: featuredLabel.frame.height * 0.7)!]));
        
        featuredLabel.attributedText = featuredLabelText;
        featuredLabel.textColor = UIColor.init(hex: "#c22b2b");
        featuredLabel.textContainerInset = UIEdgeInsets(top: -1, left: homePageHorizontalPadding, bottom: 0, right: homePageHorizontalPadding);
        featuredLabel.textContainer.lineFragmentPadding = .zero;
        
        //featuredLabel.backgroundColor = .systemRed;
        
        nextY += featuredLabel.frame.height + verticalPadding;
        
        self.view.addSubview(featuredLabel);
        
    }
    
}
