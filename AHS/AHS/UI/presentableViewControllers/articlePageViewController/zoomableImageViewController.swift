//
//  zoomableImageViewController.swift
//  AHS
//
//  Created by Richard Wei on 6/3/21.
//

import Foundation
import UIKit

class zoomableImageViewController : presentableViewController, UIScrollViewDelegate{
    
    public var image : UIImage?;
    
    private let scrollView = UIScrollView();
    private let imageView = UIImageView();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
        scrollView.alwaysBounceVertical = false;
        scrollView.alwaysBounceHorizontal = false;
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 6.0;
        scrollView.backgroundColor = BackgroundColor;
        scrollView.delegate = self;
        
        self.view.addSubview(scrollView);
        
        //
        
        imageView.frame = CGRect(x: 0, y: AppUtility.safeAreaInset.top, width: scrollView.frame.width, height: scrollView.frame.height - AppUtility.safeAreaInset.top);
        imageView.image = image;
        imageView.contentMode = .scaleAspectFit;
        
        scrollView.addSubview(imageView);
        
        //
        
        let exitButtonFrame = CGRect(x: 0, y: AppUtility.safeAreaInset.top, width: self.view.frame.width, height: self.view.frame.width * 0.08);
        let exitButton = UIButton(frame: exitButtonFrame);
        
        exitButton.backgroundColor = .clear;
        exitButton.addTarget(self, action: #selector(self.exit), for: .touchUpInside);
        
        self.view.addSubview(exitButton);
        
        //
        
        let exitButtonImageViewSize = exitButton.frame.height;
        let exitButtonImageViewFrame = CGRect(x: 0, y: 0, width: exitButtonImageViewSize, height: exitButtonImageViewSize);
        let exitButtonImageView = UIImageView(frame: exitButtonImageViewFrame);
        
        exitButtonImageView.backgroundColor = .clear;
        exitButtonImageView.tintColor = BackgroundGrayColor;
        exitButtonImageView.image = UIImage(systemName: "chevron.left");
        exitButtonImageView.contentMode = .scaleAspectFit;
        
        exitButton.addSubview(exitButtonImageView);
        
        //
        
        setupPanGesture();
        
    }
    
    //
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView;
    }
    
    @objc internal func exit(){
        self.dismiss(animated: true);
    }
}
