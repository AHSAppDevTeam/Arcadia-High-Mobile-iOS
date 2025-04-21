//
//  CalenderCell.swift
//  AHS
//
//  Created by Akshaj Kanumuri on 2/11/25.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    let dateLabel: UILabel = {
        let label = UILabel();
        label.textAlignment = .center;
        label.font = UIFont.systemFont(ofSize: 16);
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label;
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]);
        
        contentView.layer.borderWidth = 1;
        contentView.layer.borderColor = UIColor.gray.cgColor;
        contentView.layer.cornerRadius = 10;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
}
