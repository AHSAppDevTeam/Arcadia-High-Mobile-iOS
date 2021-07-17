//
//  savedPageSortByCell.swift
//  AHS
//
//  Created by Richard Wei on 7/8/21.
//

import Foundation
import UIKit

class savedPageSortByCell : UITableViewCell{
    static let identifier : String = "savedPageSortByCell";

    private let horizontalPadding : CGFloat = 5;
    
    //
    
    private let titleLabel : UILabel = UILabel();

    //
    
    private let optionsView : UIView = UIView();
    private let optionsSwitch : UISwitch = UISwitch();
    private let optionsLabel : UILabel = UILabel();
    
    //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier);
    
        //
        
        self.contentView.addSubview(titleLabel);
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: horizontalPadding).isActive = true;
        titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true;
        titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true;
        titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        
        titleLabel.textAlignment = .left;
        titleLabel.textColor = InverseBackgroundColor;
        titleLabel.font = UIFont(name: SFProDisplay_Regular, size: titleLabel.font.pointSize);
        titleLabel.numberOfLines = 1;
        
        ///
        
        self.contentView.addSubview(optionsView);
        
        optionsView.translatesAutoresizingMaskIntoConstraints = false;
        
        optionsView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true;
        optionsView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true;
        optionsView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true;
        optionsView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true;
        
        //
        
        optionsView.addSubview(optionsLabel);
        
        optionsLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        optionsLabel.leadingAnchor.constraint(equalTo: optionsView.leadingAnchor, constant: horizontalPadding).isActive = true;
        optionsLabel.topAnchor.constraint(equalTo: optionsView.topAnchor).isActive = true;
        optionsLabel.bottomAnchor.constraint(equalTo: optionsView.bottomAnchor).isActive = true;
        //optionsLabel.trailingAnchor.constraint(greaterThanOrEqualTo: optionsSwitch.leadingAnchor, constant: horizontalPadding).isActive = true;
        
        optionsLabel.textAlignment = .left;
        optionsLabel.textColor = InverseBackgroundColor;
        optionsLabel.font = UIFont(name: SFProDisplay_Regular, size: optionsLabel.font.pointSize);
        optionsLabel.numberOfLines = 1;
        
        //
        
        optionsView.addSubview(optionsSwitch);
        
        optionsSwitch.translatesAutoresizingMaskIntoConstraints = false;
        
        optionsSwitch.leadingAnchor.constraint(greaterThanOrEqualTo: optionsLabel.trailingAnchor, constant: horizontalPadding).isActive = true;
        optionsSwitch.topAnchor.constraint(equalTo: optionsView.topAnchor).isActive = true;
        optionsSwitch.bottomAnchor.constraint(equalTo: optionsView.bottomAnchor).isActive = true;
        optionsSwitch.trailingAnchor.constraint(equalTo: optionsView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        
        optionsSwitch.preferredStyle = .checkbox;
        optionsSwitch.isUserInteractionEnabled = false;
        
        //
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    override func prepareForReuse() {
        super.prepareForReuse();
        self.reset();
    }
    
    //
    
    public func renderOption(_ index: Int, _ height: CGFloat){
        titleLabel.isHidden = true;
        optionsView.isHidden = false;
        
        optionsSwitch.resize(newHeight: height * 0.7);
        optionsSwitch.isOn = dataManager.preferencesStruct.savedArticlesSortPreference.getOptionWithIndex(index);
        
        optionsLabel.text = savedSortingStruct.optionNameFromIndex(index);
        optionsLabel.font = UIFont(name: optionsLabel.font.fontName, size: height * 0.55);
        
    }
    
    public func updateOptions() -> Bool{
        
        optionsSwitch.setOn(!optionsSwitch.isOn, animated: true);
        
        return optionsSwitch.isOn;
    }
    
    public func renderMethod(_ index: Int, _ height: CGFloat){ // 0 based
        titleLabel.isHidden = false;
        optionsView.isHidden = true;
        
        titleLabel.text = savedSortingStruct.savedSortingMethods.nameFromIndex(index);
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: height * 0.55);
    }
    
    private func reset(){
        titleLabel.text = "";
    }
    
}

