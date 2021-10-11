//
//  schedulePageViewControllerCalendarDayCell.swift
//  AHS
//
//  Created by Richard Wei on 10/8/21.
//

import Foundation
import UIKit
import JTAppleCalendar

class ScheduleCalendarDayCell : JTACDayCell{
    static let identifier : String = "ScheduleCalendarDayCell";
    
    internal let dateLabel : UILabel = UILabel();
    internal let colorStrip : UIView = UIView();
    
    //
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.contentView.backgroundColor = backgroundColor;
        self.contentView.isUserInteractionEnabled = false;
        
        //
        
        self.contentView.addSubview(colorStrip);
        
        colorStrip.translatesAutoresizingMaskIntoConstraints = false;
        
        let colorStripHeight : CGFloat = self.contentView.frame.height / 20;
        colorStrip.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true;
        colorStrip.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true;
        colorStrip.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true;
        colorStrip.heightAnchor.constraint(equalToConstant: colorStripHeight).isActive = true;
        
        colorStrip.backgroundColor = BackgroundGrayColor;
        
        //
        
        self.contentView.addSubview(dateLabel);
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        dateLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true;
        dateLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true;
        
        dateLabel.textColor = InverseBackgroundColor;
        dateLabel.font = UIFont(name: SFProDisplay_Semibold, size: self.contentView.frame.height / 5);
        
        //
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    override func prepareForReuse() {
        super.prepareForReuse();
        self.reset();
    }
    
    private func reset(){
        dateLabel.text = "";
        dateLabel.textColor = InverseBackgroundColor;
        
        colorStrip.backgroundColor = BackgroundGrayColor;
        self.contentView.backgroundColor = BackgroundColor;
    }
    
    //
    
    public func updateWithDate(_ date: Date, _ cellState: CellState){
        
        dateLabel.text = String(Calendar.current.component(.day, from: date));
    
        //dateLabel.textColor = cellState.dateBelongsTo == .thisMonth ? (cellState.isSelected ? BackgroundColor : InverseBackgroundColor) : (cellState.isSelected ? BackgroundGrayColor : InverseBackgroundGrayColor);
        
        self.updateSelectedState(cellState);
        
    }
    
    public func updateSelectedState(_ cellState: CellState){
        
        if (cellState.isSelected){
            
            self.contentView.backgroundColor = InverseBackgroundColor;
            dateLabel.textColor = cellState.dateBelongsTo == .thisMonth ? BackgroundColor : BackgroundGrayColor;
            
        }
        else{
            
            self.contentView.backgroundColor = BackgroundColor;
            dateLabel.textColor = cellState.dateBelongsTo == .thisMonth ? InverseBackgroundColor : InverseBackgroundGrayColor;
            
        }
        
    }
    
    
}
