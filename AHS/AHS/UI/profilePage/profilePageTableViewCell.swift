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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier);
    
        let view = UIView();
        
        self.contentView.addSubview(view);
        
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true;
        view.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true;
        view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true;
        view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true;
        view.heightAnchor.constraint(equalToConstant: 10).isActive = true;
        
        view.backgroundColor = .systemRed;
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    override func prepareForReuse() {
        super.prepareForReuse();
        self.reset();
    }
    
    //
    
    private func reset(){
    }
    
}

