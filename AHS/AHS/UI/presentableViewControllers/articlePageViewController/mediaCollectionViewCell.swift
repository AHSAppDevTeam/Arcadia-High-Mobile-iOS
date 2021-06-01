//
//  mediaCollectionViewCell.swift
//  AHS
//
//  Created by Richard Wei on 5/29/21.
//

import Foundation
import UIKit
import youtube_ios_player_helper

class mediaCollectionViewCell : UICollectionViewCell{
    static let identifier : String = "mediaCollectionViewCell";
    
    internal let imageView = UIImageView();
    internal let videoView = YTPlayerView();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        imageView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height);
        imageView.backgroundColor = .systemRed;
        imageView.contentMode = .scaleAspectFill;
        
        imageView.isHidden = true;
        
        self.contentView.addSubview(imageView);
        
        //
        
        videoView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height);
        videoView.backgroundColor = .systemRed;
        
        self.contentView.addSubview(videoView);
        
        //
        
        self.contentView.clipsToBounds = true;
        self.contentView.layer.cornerRadius = self.contentView.frame.height / 12;
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