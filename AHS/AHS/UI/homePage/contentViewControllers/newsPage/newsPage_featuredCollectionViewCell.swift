//
//  newsPage_featuredCellClass.swift
//  AHS
//
//  Created by Richard Wei on 4/8/21.
//

import Foundation
import UIKit
import UPCarouselFlowLayout
import SDWebImage

class featuredCollectionViewCell : UICollectionViewCell{
    
    static let identifier : String = "featuredCollectionViewCell";
   
    internal let imageView = UIImageView();
    
    override init(frame: CGRect){
        super.init(frame: frame);
        
        imageView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height);
        imageView.backgroundColor = .systemRed;
        imageView.contentMode = .scaleAspectFill;
        
        self.contentView.addSubview(imageView);
        self.contentView.clipsToBounds = true;
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
    
    public func updateImage(_ previewImageURL: String, _ articleID: String){
        reset();
        render(previewImageURL, articleID);
    }
    
    public func setPlaceholderImage(){
        imageView.image = placeholderImage;
    }
    
    private func render(_ previewImageURL: String, _ articleID: String){
        //print("Rendering with preview \(previewImageURL) and \(articleID)");
        imageView.setImageURL(previewImageURL, completion: {
            //print("Finished leading preview")
            dataManager.getArticleFullPreviewImageURL(articleID, completion: { (imageURL) in
                //print("full image loaded for \(articleID)")
                self.imageView.setImageURL(imageURL);
            })
            //self.imageView.setImageURL(imageURL);
        });
    }
    
    private func reset(){
        imageView.image = UIImage();
    }
    
}


