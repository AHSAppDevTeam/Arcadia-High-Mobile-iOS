//
//  newsPage_featuredCellClass.swift
//  AHS
//
//  Created by Richard Wei on 4/8/21.
//

import Foundation
import UIKit
import UPCarouselFlowLayout

class featuredCollectionViewCell : UICollectionViewCell{
    
    static let identifier : String = "featuredCollectionCell";
    static let colors : [UIColor] = [.systemRed, .systemBlue, .systemPink, .systemTeal, .systemGray, .systemGreen, .systemOrange, .systemYellow, .systemIndigo, .systemIndigo];
    
    override init(frame: CGRect){
        super.init(frame: frame);
        
        //self.contentView.backgroundColor = .systemRed;
        self.contentView.layer.cornerRadius = self.contentView.frame.height / 12;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse();
        self.reset();
    }
    //
    
    public func update(_ index: Int){
        self.contentView.backgroundColor = featuredCollectionViewCell.colors[index];
    }
    
    public func updateWithData(_ data: baseArticleData){
        reset();
        render(data);
    }
    
    private func render(_ data: baseArticleData){
        
    }
    
    private func reset(){
        
    }
    
}


