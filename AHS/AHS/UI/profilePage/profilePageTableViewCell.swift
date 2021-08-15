//
//  profilePageTableViewCell.swift
//  AHS
//
//  Created by Richard Wei on 8/5/21.
//

import Foundation
import UIKit

class profilePageTableViewCell : UITableViewCell{
    static let identifier : String = "profilePageTableViewCell";
    
    //
    
    internal let horizontalPadding : CGFloat = 10;
    
    internal let fontRatio : CGFloat = 0.48;
    internal let textColor : UIColor = BackgroundGrayColor;
    
    internal let titleLabel : UILabel = UILabel();
    internal let valueLabel : UILabel = UILabel();
    internal let chevronImageView : UIImageView = UIImageView();
    
    //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        //
        
        self.contentView.addSubview(titleLabel);
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: horizontalPadding).isActive = true;
        titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true;
        titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true;
        
        titleLabel.textColor = textColor;
        titleLabel.textAlignment = .left;
        titleLabel.font = UIFont(name: SFProDisplay_Semibold, size: profilePageViewController.contentTableViewRowHeight * fontRatio);
        titleLabel.numberOfLines = 1;
        
        titleLabel.isHidden = true;
        titleLabel.tag = 1;
        
        //
        
        self.contentView.addSubview(valueLabel);
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: horizontalPadding).isActive = true;
        valueLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true;
        valueLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true;
        valueLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        
        valueLabel.textColor = textColor;
        valueLabel.textAlignment = .right;
        valueLabel.font = UIFont(name: SFProDisplay_Medium, size: profilePageViewController.contentTableViewRowHeight * fontRatio);
        valueLabel.numberOfLines = 1;
        
        valueLabel.isHidden = true;
        valueLabel.tag = 1;
        
        //
        
        self.contentView.addSubview(chevronImageView);
        
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false;
        
        chevronImageView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: horizontalPadding).isActive = true;
        chevronImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true;
        chevronImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true;
        chevronImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        
        chevronImageView.contentMode = .scaleAspectFit;
        chevronImageView.tintColor = textColor;
        chevronImageView.image = UIImage(systemName: "chevron.right");
        
        chevronImageView.isHidden = true;
        chevronImageView.tag = 1;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    override func prepareForReuse() {
        super.prepareForReuse();
        self.reset();
    }
    
    static private func getCellSize(_ section: Int) -> CGSize{
        return CGSize(width: AppUtility.getCurrentScreenSize().width - 2*profilePageViewController.horizontalPadding, height: profilePageViewController.getHeightForSection(section));
    }
    
    //
    
    public func updateWithView(_ section: Int, _ view: UIView){
        
        titleLabel.isHidden = true;
        valueLabel.isHidden = true;
        chevronImageView.isHidden = true;
        
        //
        
        view.removeFromSuperview();
        
        //
        
        self.contentView.addSubview(view);
        
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        view.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: profilePageViewController.verticalPadding).isActive = true;
        view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true;
        view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -profilePageViewController.verticalPadding).isActive = true;
        view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true;
    }
    
    public func updateWithButton(_ section: Int, title: String, value: String?){
        
        titleLabel.isHidden = false;
        
        titleLabel.text = title;
        
        if let val = value{
            valueLabel.isHidden = false;
            chevronImageView.isHidden = true;
            
            valueLabel.text = val;
        }
        else{
            valueLabel.isHidden = true;
            chevronImageView.isHidden = false;
        }
        
    }
    
    //
    
    private func reset(){
        for subview in self.contentView.subviews{
            if subview.tag != 1{
                subview.removeFromSuperview();
            }
        }
        
        titleLabel.isHidden = true;
        titleLabel.text = "";
        
        valueLabel.isHidden = true;
        valueLabel.text = "";
        
        chevronImageView.isHidden = true;
    }
    
}

