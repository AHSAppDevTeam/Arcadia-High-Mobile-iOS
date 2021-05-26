//
//  InfoTextViewCellTableViewCell.swift
//  AHS
//
//  Created by Joshua McMahon on 4/20/21.
//

import UIKit


//This class is used to crete the attributes for the Info 
class infoTableViewCell: UITableViewCell {

    static public let identifier = "infoTableViewCell";
    
    lazy var backView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 380, height: 50))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var buttonTitle: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 10, y: 8, width: backView.frame.width - 116, height: 30))
        lbl.textAlignment = .left
        lbl.font = UIFont.boldSystemFont(ofSize: 18)

        return lbl
    }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        backView.layer.cornerRadius = 0
        backView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
        backView.addSubview(buttonTitle)
        // Configure the view for the selected state
    }

}


