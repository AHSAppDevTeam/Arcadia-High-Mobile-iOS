//
//  termsAndConditionsPageViewController.swift
//  AHS
//
//  Created by Richard Wei on 8/29/21.
//

import Foundation
import UIKit

class termsAndConditionsPageViewController : presentableViewController{
    
    //
    
    internal let dismissButton = UIButton();
    
    //
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
        self.setupPanGesture();
        
        self.view.backgroundColor = BackgroundColor;
        
        //
        
        let dismissButtonWidth = self.view.frame.width;
        let dismissButtonHeight = dismissButtonWidth * 0.09;
        
        dismissButton.frame = CGRect(x: 0, y: AppUtility.safeAreaInset.top, width: dismissButtonWidth, height: dismissButtonHeight);
        
        let dismissButtonHorizontalPadding : CGFloat = 10;
        let dismissButtonVerticalPadding : CGFloat = 5;
        
        //
        
        let dismissImageViewSize = dismissButton.frame.height - 2*dismissButtonVerticalPadding;
        
        let dismissImageViewFrame = CGRect(x: dismissButtonHorizontalPadding, y: dismissButtonVerticalPadding, width: dismissImageViewSize, height: dismissImageViewSize);
        let dismissImageView = UIImageView(frame: dismissImageViewFrame);
        
        dismissImageView.image = UIImage(systemName: "chevron.left");
        dismissImageView.contentMode = .scaleAspectFit;
        dismissImageView.tintColor = InverseBackgroundColor;
        
        dismissButton.addSubview(dismissImageView);
        
        //
        
        let dismissTitleLabelFrame = CGRect(x: dismissImageView.frame.maxX + dismissButtonHorizontalPadding, y: dismissButtonVerticalPadding, width: dismissButton.frame.width - 2*(dismissImageView.frame.maxX + dismissButtonHorizontalPadding), height: dismissButton.frame.height - 2*dismissButtonVerticalPadding);
        let dismissTitleLabel = UILabel(frame: dismissTitleLabelFrame);
        
        dismissTitleLabel.text = "Terms and Agreements";
        dismissTitleLabel.textAlignment = .center;
        dismissTitleLabel.textColor = InverseBackgroundColor;
        dismissTitleLabel.font = UIFont(name: SFProDisplay_Bold, size: dismissTitleLabel.frame.height * 0.8);
        
        dismissButton.addSubview(dismissTitleLabel);
        
        //
        
        dismissButton.addTarget(self, action: #selector(self.handleBackButton), for: .touchUpInside);
        
        self.view.addSubview(dismissButton);
        
        //
        
        renderContent();
        
    }
    
    @objc internal func handleBackButton(_ button: UIButton){
        self.dismiss(animated: true);
    }
    
    //
    
    internal func renderContent(){
    
        let textViewFrame = CGRect(x: 0, y: dismissButton.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - dismissButton.frame.maxY);
        let textView = UITextView(frame: textViewFrame);
        
        textView.backgroundColor = .clear;
        textView.attributedText = termsAndConditionsRawHTML.htmlAttributedString();
        textView.textColor = InverseBackgroundColor;
        textView.isEditable = false;
        textView.font = UIFont(name: SFProDisplay_Regular, size: self.view.frame.width / 30);
        
        self.view.insertSubview(textView, at: 0);
    
        
    }
    
}
