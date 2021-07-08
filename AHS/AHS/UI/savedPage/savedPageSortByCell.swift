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

    private let titleLabel : UILabel = UILabel();
    
    //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier);
    
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height);
        titleLabel.textAlignment = .left;
        titleLabel.textColor = InverseBackgroundColor;
        titleLabel.font = UIFont(name: SFProDisplay_Regular, size: titleLabel.frame.height * 0.2);
        titleLabel.numberOfLines = 1;
        
        self.contentView.addSubview(titleLabel);
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    override func prepareForReuse() {
        super.prepareForReuse();
        self.reset();
    }
    
    //
    
    public func update(_ index: Int){ // 0 based
        titleLabel.text = savedSortingMethods.nameFromIndex(index);
    }
    
    private func reset(){
        titleLabel.text = "";
    }
    
}

