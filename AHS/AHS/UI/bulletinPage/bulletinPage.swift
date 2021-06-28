//
//  bulletinPage.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

class bulletinPageViewController : mainPageViewController{
    
    init(){
        super.init(nibName: nil, bundle: nil);
        self.pageName = "Student";
        self.secondaryPageName = "Bulletin";
        self.viewControllerIconName = "doc.plaintext.fill";
    }
    
    required init?(coder: NSCoder) { // required uiviewcontroller init
        super.init(coder: coder);
    }
    
    //
    
    internal let comingUpMaxArticleCount : Int = 4;
    
    internal let mainScrollView : UIScrollView = UIScrollView();
    internal let verticalPadding : CGFloat = 5;
    internal let horizontalPadding : CGFloat = 10;
    
    internal let refreshControl : UIRefreshControl = UIRefreshControl();

    internal let categoryScrollView : UIButtonScrollView  = UIButtonScrollView();
    internal var categoryScrollViewNextContentX : CGFloat = 0;
    
    internal var contentViewWidth : CGFloat = 0;
    
    internal let comingUpLabel : UILabel = UILabel();
    internal let comingUpContentView : UIView = UIView();
    
    internal let bulletinContentView : UIView = UIView();
    
    internal var bulletinCategoryDictionary : [String : Bool] = [:];
    internal var bulletinArticleIDList : [String] = [];
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
        contentViewWidth = AppUtility.getCurrentScreenSize().width - 2*horizontalPadding;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if (!self.hasBeenSetup){
            
            mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
            mainScrollView.alwaysBounceVertical = true;
            self.view.addSubview(mainScrollView);
            
            mainScrollView.addSubview(refreshControl);
            refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged);
            
            renderLayout();
            reset();
            loadBulletinData();
            
            self.hasBeenSetup = true;
        }
        
    }
    
    internal func renderLayout(){
        
        //
        
        let categoryScrollViewWidth = mainScrollView.frame.width;
        let categoryScrollViewHeight = categoryScrollViewWidth * 0.26;
    
        mainScrollView.addSubview(categoryScrollView);
        categoryScrollView.translatesAutoresizingMaskIntoConstraints = false;
        
        categoryScrollView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true;
        categoryScrollView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        categoryScrollView.widthAnchor.constraint(equalToConstant: categoryScrollViewWidth).isActive = true;
        categoryScrollView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor).isActive = true;
        categoryScrollView.heightAnchor.constraint(equalToConstant: categoryScrollViewHeight).isActive = true;
        
        //categoryScrollView.backgroundColor = .systemRed;
        categoryScrollView.showsHorizontalScrollIndicator = false;
        categoryScrollView.canCancelContentTouches = true;
        
        //
        
        mainScrollView.addSubview(comingUpLabel);
        comingUpLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        let comingUpLabelWidth = mainScrollView.frame.width;
        let comingUpLabelHeight = comingUpLabelWidth * 0.13;
        
        comingUpLabel.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: horizontalPadding).isActive = true;
        comingUpLabel.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: verticalPadding).isActive = true;
        comingUpLabel.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        comingUpLabel.heightAnchor.constraint(equalToConstant: comingUpLabelHeight).isActive = true;
        
        
        let comingUpAttributedText = NSMutableAttributedString(string: "Coming ", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: comingUpLabelHeight * 0.5)!]);
        comingUpAttributedText.append(NSAttributedString(string: "Up", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Regular, size: comingUpLabelHeight * 0.5)!]));
        
        comingUpLabel.attributedText = comingUpAttributedText;
        comingUpLabel.textColor = UIColor.init(hex: "#d8853d");
        comingUpLabel.textAlignment = .left;
    
        //comingUpLabel.backgroundColor = .systemBlue;
        
        //
        
        mainScrollView.addSubview(comingUpContentView);
        comingUpContentView.translatesAutoresizingMaskIntoConstraints = false;
        
        comingUpContentView.topAnchor.constraint(equalTo: comingUpLabel.bottomAnchor, constant: verticalPadding).isActive = true;
        comingUpContentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: horizontalPadding).isActive = true;
        comingUpContentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        
        //comingUpContentViewHeightConstraint = comingUpContentView.heightAnchor.constraint(equalToConstant: 0);
        //comingUpContentViewHeightConstraint.isActive = true;
        
        //
        
        mainScrollView.addSubview(bulletinContentView);
        bulletinContentView.translatesAutoresizingMaskIntoConstraints = false;
        
        bulletinContentView.topAnchor.constraint(equalTo: comingUpContentView.bottomAnchor, constant: verticalPadding).isActive = true;
        bulletinContentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: horizontalPadding).isActive = true;
        bulletinContentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        
        bulletinContentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -verticalPadding).isActive = true;
        
        
    }
    
    internal func reset(){
        
        resetArticleParser();
        
        categoryScrollViewNextContentX = horizontalPadding;
        
        for subview in categoryScrollView.subviews{
            subview.removeFromSuperview();
        }
        
        //
        
        for subview in comingUpContentView.subviews{
            subview.removeFromSuperview();
        }
        
        //
        
        for subview in bulletinContentView.subviews{
            subview.removeFromSuperview();
        }
        
    }
    
    internal func loadBulletinData(){
        
        self.refreshControl.beginRefreshing();
        
        dataManager.getBulletinLocationData(completion: { (locationdata) in
            
            DispatchQueue.global(qos: .background).async {
                
                let dispatchGroup = DispatchGroup();
                
                for categoryID in locationdata.categoryIDs{
                    
                    dispatchGroup.enter();
                    
                    DispatchQueue.main.async {
                        
                        dataManager.getCategoryData(categoryID, completion: { (categorydata) in
                            
                            self.renderCategory(categorydata);
                            self.appendCategory(categorydata.categoryID, categorydata.articleIDs);
                            
                            dispatchGroup.leave();
                            
                        });
                        
                    }
                    
                }
                
                dispatchGroup.wait();
                
                DispatchQueue.main.async {
                    
                    dataManager.loadBulletinArticleList(self.bulletinArticleIDList, completion: { () in
                        
                        self.refreshControl.endRefreshing();
                        self.updateArticleList();
                        
                    });
                    
                }
                
            }
            
        });
        
    }
    
    internal func renderCategory(_ categorydata: categoryData){
        
        let categoryViewFrame = CGRect(x: categoryScrollViewNextContentX, y: 0, width: categoryScrollView.frame.height * 0.78, height: categoryScrollView.frame.height);
        let categoryView = CategoryButton(frame: categoryViewFrame);
        
        categoryView.layer.cornerRadius = categoryView.frame.height / 10;
        categoryView.layer.borderColor = categorydata.color.cgColor;
        categoryView.layer.borderWidth = 3;
        //categoryView.isUserInteractionEnabled = false;
        //categoryView.backgroundColor = categorydata.color;
        
        //
        
        let categoryImageViewPadding = categoryView.frame.width / 5;
        let categoryImageViewSize = categoryView.frame.width - 2*categoryImageViewPadding;
        let categoryImageViewFrame = CGRect(x: categoryImageViewPadding, y: categoryImageViewPadding, width: categoryImageViewSize, height: categoryImageViewSize);
        let categoryImageView = UIImageView(frame: categoryImageViewFrame);
        
        categoryImageView.isUserInteractionEnabled = false;
        categoryImageView.contentMode = .scaleAspectFit;
        categoryImageView.sd_setImage(with: URL(string: categorydata.iconURL), completed: { (image, error, type, url) in
            if error == nil {
                categoryImageView.image = image?.withRenderingMode(.alwaysTemplate);
                categoryImageView.tintColor = categorydata.color;
            }
        });
        
        categoryView.addSubview(categoryImageView);
        
        //
        
        let categoryLabelHorizontalPadding : CGFloat = categoryView.frame.width / 10;
        let categoryLabelFrame = CGRect(x: categoryLabelHorizontalPadding, y: categoryImageView.frame.maxY + categoryImageViewPadding, width: categoryView.frame.width - 2*categoryLabelHorizontalPadding, height: categoryView.frame.height - (categoryImageView.frame.maxY + categoryImageViewPadding + (categoryImageViewPadding / 2)));
        let categoryLabel = UILabel(frame: categoryLabelFrame);
        
        //categoryLabel.backgroundColor = .systemRed;
        categoryLabel.isUserInteractionEnabled = false;
        categoryLabel.textColor = categorydata.color;
        categoryLabel.text = categorydata.title;
        categoryLabel.textAlignment = .center;
        categoryLabel.font = UIFont(name: SFProDisplay_Semibold, size: categoryLabel.frame.height * 0.8);
        categoryLabel.adjustsFontSizeToFitWidth = true;
        
        categoryLabel.tag = 1;
        categoryView.addSubview(categoryLabel);
        
        //
        
        categoryView.isSelected = false;
        categoryView.categoryID = categorydata.categoryID;
        categoryView.addTarget(self, action: #selector(self.handleCategoryButton), for: .touchUpInside);
        
        categoryScrollView.addSubview(categoryView);
        categoryScrollViewNextContentX += categoryView.frame.width + horizontalPadding;
        
        categoryScrollView.contentSize = CGSize(width: categoryScrollViewNextContentX, height: categoryScrollView.frame.height);
        
    }
    
    // these functions will be called by the article parser

    internal func renderComingUp(_ articleIDs: [String]){
        for subview in comingUpContentView.subviews{
            subview.removeFromSuperview();
        }
        
        //
        
        //comingUpContentView.backgroundColor = .systemRed;
        
        var nextTopAnchorContraint = comingUpContentView.topAnchor;
        
        for articleID in articleIDs{
            
            let articleView = UIView();
            
            articleView.translatesAutoresizingMaskIntoConstraints = false;
            
            comingUpContentView.addSubview(articleView);
            
            articleView.leadingAnchor.constraint(equalTo: comingUpContentView.leadingAnchor).isActive = true;
            articleView.trailingAnchor.constraint(equalTo: comingUpContentView.trailingAnchor).isActive = true;
            articleView.widthAnchor.constraint(equalToConstant: contentViewWidth).isActive = true;
            articleView.topAnchor.constraint(equalTo: nextTopAnchorContraint, constant: verticalPadding).isActive = true;
            
            let articleViewHeight = contentViewWidth * 0.26;
            articleView.heightAnchor.constraint(equalToConstant: articleViewHeight).isActive = true;
            
            articleView.backgroundColor = .systemBlue;
            
            nextTopAnchorContraint = articleView.bottomAnchor;
            
        }

        nextTopAnchorContraint.constraint(equalTo: comingUpContentView.bottomAnchor, constant: -verticalPadding).isActive = true;
        
    }
    
    internal func renderArticleList(_ articleIDs: [String]){
        for subview in bulletinContentView.subviews{
            subview.removeFromSuperview();
        }
        
        
    }
    
}

