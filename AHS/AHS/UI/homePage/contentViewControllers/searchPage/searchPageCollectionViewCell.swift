//
//  searchPageCollectionViewCell.swift
//  AHS
//
//  Created by Richard Wei on 5/25/21.
//

import Foundation
import UIKit
import SDWebImage

class searchPageCollectionViewCell : UITableViewCell{
    static let identifier : String = "searchPageCollectionViewCell";
    
    //
    
    let articleImageView = UIImageView();
    let articleTitleLabel = UILabel();
    
    let horizontalPadding : CGFloat = 5;
    
    //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        articleImageView.frame = CGRect(x: horizontalPadding, y: 0, width: self.contentView.frame.width * 0.2 - 2*horizontalPadding, height: self.contentView.frame.height);
        articleImageView.backgroundColor = .clear;
        articleImageView.contentMode = .scaleAspectFit;
        articleImageView.clipsToBounds = true;
        
        self.contentView.addSubview(articleImageView);
        
        articleTitleLabel.frame = CGRect(x: articleImageView.frame.maxX + horizontalPadding, y: 0, width: self.contentView.frame.width - articleImageView.frame.maxX - horizontalPadding, height: self.contentView.frame.height);
        articleTitleLabel.backgroundColor = .clear;
        articleTitleLabel.textColor = InverseBackgroundColor;
        articleTitleLabel.font = UIFont(name: SFProDisplay_Semibold, size: self.contentView.frame.height * 0.4);
        articleTitleLabel.textAlignment = .left;
        
        self.contentView.addSubview(articleTitleLabel);
        
        self.contentView.backgroundColor = BackgroundColor;
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    override func prepareForReuse() {
        super.prepareForReuse();
        self.reset();
    }
    
    //
    
    public func updateContent(_ data: articleSnippetData){
        reset();
        if (data.thumbURLs.count > 0){
            articleImageView.frame = CGRect(x: horizontalPadding, y: 0, width: self.contentView.frame.width * 0.2 - 2*horizontalPadding, height: self.contentView.frame.height);
            articleTitleLabel.frame = CGRect(x: articleImageView.frame.maxX + horizontalPadding, y: 0, width: self.contentView.frame.width - articleImageView.frame.maxX - 2*horizontalPadding, height: self.contentView.frame.height);
            articleImageView.setImageURL(data.thumbURLs[0]);
        }
        else{
            articleImageView.frame = CGRect(x: 0, y: 0, width: 0, height: self.contentView.frame.height);
            articleTitleLabel.frame = CGRect(x: horizontalPadding, y: 0, width: self.contentView.frame.width - 2*horizontalPadding, height: self.contentView.frame.height);
            articleImageView.image = UIImage();
        }
        articleTitleLabel.text = data.title;
    }
    
    private func reset(){
        articleImageView.image = UIImage();
        articleTitleLabel.text = "";
    }
    
}
