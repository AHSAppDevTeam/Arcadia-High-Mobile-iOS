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
    
        self.contentView.addSubview(titleLabel);
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true;
        titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true;
        titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true;
        titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true;
        
        titleLabel.textAlignment = .center;
        titleLabel.textColor = InverseBackgroundColor;
        titleLabel.font = UIFont(name: SFProDisplay_Regular, size: titleLabel.font.pointSize);
        titleLabel.numberOfLines = 1;
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    override func prepareForReuse() {
        super.prepareForReuse();
        self.reset();
    }
    
    //
    
    public func update(_ index: Int, _ height: CGFloat){ // 0 based
        titleLabel.text = savedSortingMethods.nameFromIndex(index);
        titleLabel.font = UIFont(name: SFProDisplay_Regular, size: height * 0.5);
    }
    
    private func reset(){
        titleLabel.text = "";
    }
    
}

