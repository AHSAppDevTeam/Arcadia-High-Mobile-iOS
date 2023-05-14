//
//  breakfastViewController.swift
//  AHS
//
//  Created by Mathew Xie on 4/27/23.
//

import Foundation
import UIKit

class breakfastViewController : presentableViewController, UIScrollViewDelegate {
    internal let mainScrollView : UIButtonScrollView = UIButtonScrollView();
    internal var nextY : CGFloat = 0;
    internal var topCategoryPickerButtons : [UIButton] = [];
    internal let horizontalPadding : CGFloat = 10;
    internal let verticalPadding : CGFloat = 5;
    internal let mainEntreeLabel : UILabel = UILabel()
    internal let snackLabel: UILabel = UILabel()
    internal let milkLabel: UILabel = UILabel()
    internal let menuColor : UIColor = .cyan
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
        nextY = 0
        mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
        mainScrollView.alwaysBounceVertical = true;
        self.view.addSubview(mainScrollView);
        setupEntree()
        setupSnacks()
        setupMilk()
    }
    
    private func setupEntree() {
        let blockHeight : CGFloat = mainScrollView.frame.width * 0.2
        let mainEntreeWidth: CGFloat = mainScrollView.frame.width - 2 * homePageHorizontalPadding;
        let mainEntreeHeight: CGFloat = mainEntreeWidth * 0.1
        mainEntreeLabel.frame = CGRect(x: homePageHorizontalPadding, y: nextY, width: mainEntreeWidth, height: mainEntreeHeight)
        
        mainEntreeLabel.text = "Main Entree";
        mainEntreeLabel.textAlignment = .left;
        mainEntreeLabel.textColor = menuColor;
        mainEntreeLabel.font = UIFont(name: SFProDisplay_Bold, size: mainEntreeLabel.frame.height * 0.75);
        
        mainScrollView.addSubview(mainEntreeLabel)
        
        nextY += mainEntreeHeight
        
        let entreeFrame = CGRect(x: 2 * horizontalPadding, y: nextY + verticalPadding, width: self.view.frame.width - 4 * horizontalPadding, height: 3 * blockHeight + 6 * verticalPadding)
        let entreeView = UIView(frame: entreeFrame)
        
        var localY: CGFloat = 0
        for _ in 0...2 {
            let foodViewFrame = CGRect(x: 0, y: localY + 2*verticalPadding, width: entreeView.frame.width, height: blockHeight)
            let foodView = UIView(frame: foodViewFrame);
            foodView.layer.cornerRadius = 15;
            foodView.backgroundColor = .cyan
            
            let foodLabelFontSize = foodView.frame.width * 0.08;
            
            let middleY: Int = Int(foodView.frame.height / 4) // Y-value for middle of periodView
            let foodLabelHeight: Int = Int(foodView.frame.height / 2)
            let foodLabelFrame = CGRect(x: Int(horizontalPadding), y: middleY, width: Int(foodView.frame.width) / 3, height: foodLabelHeight)
            let foodLabel = UILabel(frame: foodLabelFrame);
            foodLabel.textColor = InverseBackgroundColor;
            foodLabel.font = UIFont(name: SFProDisplay_Bold, size: foodLabelFontSize);
            foodLabel.text = "placeholder"
            foodView.addSubview(foodLabel);
                
            let foodVerticalLineWidth: CGFloat = 1;
            let foodVerticalLineFrame = CGRect(x: Int(foodLabel.frame.width) + Int(horizontalPadding), y: middleY, width: Int(foodVerticalLineWidth), height: foodLabelHeight)
            let foodVerticalLine = UIView(frame: foodVerticalLineFrame)
            foodVerticalLine.backgroundColor = .white
            foodView.addSubview(foodVerticalLine)
            
            let foodTimeLabelFrame = CGRect(x: Int(foodLabel.frame.width) + 2*Int(horizontalPadding), y: middleY, width: Int(foodView.frame.width - foodVerticalLine.frame.width), height: foodLabelHeight)
            let foodTimeLabel = UILabel(frame: foodTimeLabelFrame)
            let foodTimeLabelFontSize = foodView.frame.width * 0.07;
            
            foodTimeLabel.textColor = InverseBackgroundColor;
            foodTimeLabel.font = UIFont(name: SFProDisplay_Bold, size: foodTimeLabelFontSize);
            foodTimeLabel.numberOfLines = 3 // or 0 for infinite lines
            foodTimeLabel.text = "placeholder"
            foodView.addSubview(foodTimeLabel)
            entreeView.addSubview(foodView)
            
            
            
            localY += blockHeight + 2*verticalPadding
        }
        nextY += localY
        mainScrollView.addSubview(entreeView)
    }
    
    private func setupSnacks() {
        let blockHeight : CGFloat = mainScrollView.frame.width * 0.2
        let mainEntreeWidth: CGFloat = mainScrollView.frame.width - 2 * homePageHorizontalPadding;
        let mainEntreeHeight: CGFloat = mainEntreeWidth * 0.1
        snackLabel.frame = CGRect(x: homePageHorizontalPadding, y: nextY + 2*verticalPadding, width: mainEntreeWidth, height: mainEntreeHeight)
        
        snackLabel.text = "Snacks";
        snackLabel.textAlignment = .left;
        snackLabel.textColor = menuColor;
        snackLabel.font = UIFont(name: SFProDisplay_Bold, size: snackLabel.frame.height * 0.75);
        
        mainScrollView.addSubview(snackLabel)
        
        nextY += mainEntreeHeight + 2*verticalPadding
        
        let entreeFrame = CGRect(x: 2 * horizontalPadding, y: nextY + verticalPadding, width: self.view.frame.width - 4 * horizontalPadding, height: 3 * blockHeight + 6 * verticalPadding)
        let entreeView = UIView(frame: entreeFrame)
        
        var localY: CGFloat = 0
        for _ in 0...2 {
            let foodViewFrame = CGRect(x: 0, y: localY + 2*verticalPadding, width: entreeView.frame.width, height: blockHeight)
            let foodView = UIView(frame: foodViewFrame);
            foodView.layer.cornerRadius = 15;
            foodView.backgroundColor = .cyan
            
            let foodLabelFontSize = foodView.frame.width * 0.08;
            
            let middleY: Int = Int(foodView.frame.height / 4) // Y-value for middle of periodView
            let foodLabelHeight: Int = Int(foodView.frame.height / 2)
            let foodLabelFrame = CGRect(x: Int(horizontalPadding), y: middleY, width: Int(foodView.frame.width) / 3, height: foodLabelHeight)
            let foodLabel = UILabel(frame: foodLabelFrame);
            foodLabel.textColor = InverseBackgroundColor;
            foodLabel.font = UIFont(name: SFProDisplay_Bold, size: foodLabelFontSize);
            foodLabel.text = "placeholder"
            foodView.addSubview(foodLabel);
                
            let foodVerticalLineWidth: CGFloat = 1;
            let foodVerticalLineFrame = CGRect(x: Int(foodLabel.frame.width) + Int(horizontalPadding), y: middleY, width: Int(foodVerticalLineWidth), height: foodLabelHeight)
            let foodVerticalLine = UIView(frame: foodVerticalLineFrame)
            foodVerticalLine.backgroundColor = .white
            foodView.addSubview(foodVerticalLine)
            
            let foodTimeLabelFrame = CGRect(x: Int(foodLabel.frame.width) + 2*Int(horizontalPadding), y: middleY, width: Int(foodView.frame.width - foodVerticalLine.frame.width), height: foodLabelHeight)
            let foodTimeLabel = UILabel(frame: foodTimeLabelFrame)
            let foodTimeLabelFontSize = foodView.frame.width * 0.07;
            
            foodTimeLabel.textColor = InverseBackgroundColor;
            foodTimeLabel.font = UIFont(name: SFProDisplay_Bold, size: foodTimeLabelFontSize);
            foodTimeLabel.numberOfLines = 3 // or 0 for infinite lines
            foodTimeLabel.text = "placeholder"
            foodView.addSubview(foodTimeLabel)
            entreeView.addSubview(foodView)
            
            
            
            localY += blockHeight + 2*verticalPadding
        }
        nextY += localY
        mainScrollView.addSubview(entreeView)
    }
    
    private func setupMilk() {
        let blockHeight : CGFloat = mainScrollView.frame.width * 0.2
        let mainEntreeWidth: CGFloat = mainScrollView.frame.width - 2 * homePageHorizontalPadding;
        let mainEntreeHeight: CGFloat = mainEntreeWidth * 0.1
        milkLabel.frame = CGRect(x: homePageHorizontalPadding, y: nextY + 2 * verticalPadding, width: mainEntreeWidth, height: mainEntreeHeight)
        
        milkLabel.text = "Milk";
        milkLabel.textAlignment = .left;
        milkLabel.textColor = menuColor;
        milkLabel.font = UIFont(name: SFProDisplay_Bold, size: milkLabel.frame.height * 0.75);
        
        mainScrollView.addSubview(milkLabel)
        
        nextY += mainEntreeHeight + 2*verticalPadding
        
        let entreeFrame = CGRect(x: 2 * horizontalPadding, y: nextY + verticalPadding, width: self.view.frame.width - 4 * horizontalPadding, height: 3 * blockHeight + 6 * verticalPadding)
        let entreeView = UIView(frame: entreeFrame)
        
        var localY: CGFloat = 0
        for _ in 0...2 {
            let foodViewFrame = CGRect(x: 0, y: localY + 2*verticalPadding, width: entreeView.frame.width, height: blockHeight)
            let foodView = UIView(frame: foodViewFrame);
            foodView.layer.cornerRadius = 15;
            foodView.backgroundColor = .cyan
            
            let foodLabelFontSize = foodView.frame.width * 0.08;
            
            let middleY: Int = Int(foodView.frame.height / 4) // Y-value for middle of periodView
            let foodLabelHeight: Int = Int(foodView.frame.height / 2)
            let foodLabelFrame = CGRect(x: Int(horizontalPadding), y: middleY, width: Int(foodView.frame.width) / 3, height: foodLabelHeight)
            let foodLabel = UILabel(frame: foodLabelFrame);
            foodLabel.textColor = InverseBackgroundColor;
            foodLabel.font = UIFont(name: SFProDisplay_Bold, size: foodLabelFontSize);
            foodLabel.text = "placeholder"
            foodView.addSubview(foodLabel);
                
            let foodVerticalLineWidth: CGFloat = 1;
            let foodVerticalLineFrame = CGRect(x: Int(foodLabel.frame.width) + Int(horizontalPadding), y: middleY, width: Int(foodVerticalLineWidth), height: foodLabelHeight)
            let foodVerticalLine = UIView(frame: foodVerticalLineFrame)
            foodVerticalLine.backgroundColor = .white
            foodView.addSubview(foodVerticalLine)
            
            let foodTimeLabelFrame = CGRect(x: Int(foodLabel.frame.width) + 2*Int(horizontalPadding), y: middleY, width: Int(foodView.frame.width - foodVerticalLine.frame.width), height: foodLabelHeight)
            let foodTimeLabel = UILabel(frame: foodTimeLabelFrame)
            let foodTimeLabelFontSize = foodView.frame.width * 0.07;
            
            foodTimeLabel.textColor = InverseBackgroundColor;
            foodTimeLabel.font = UIFont(name: SFProDisplay_Bold, size: foodTimeLabelFontSize);
            foodTimeLabel.numberOfLines = 3 // or 0 for infinite lines
            foodTimeLabel.text = "placeholder"
            foodView.addSubview(foodTimeLabel)
            entreeView.addSubview(foodView)
            
            
            
            localY += blockHeight + 2*verticalPadding
        }
        nextY += localY
        mainScrollView.addSubview(entreeView)
    }

}
