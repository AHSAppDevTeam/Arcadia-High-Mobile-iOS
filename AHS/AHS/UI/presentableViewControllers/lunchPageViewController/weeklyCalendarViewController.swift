//
//  weeklyCalendarViewController.swift
//  AHS
//
//  Created by Mathew Xie on 5/8/23.
//

import Foundation
import UIKit

class weeklyCalendarViewController : presentableViewController, UIScrollViewDelegate, UICollectionViewDataSource {

    
    
    var collectionView: UICollectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionViewHeight: CGFloat = self.view.frame.height / 5;
        var collectionViewFrame: CGRect = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(collectionViewHeight))
        collectionView.frame = collectionViewFrame
        
        collectionView.dataSource = self
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "calendarCell")
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let dayOfWeek = formatter.string(from: Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * indexPath.item)))
        cell.dayLabel.text = dayOfWeek
        return cell
    }
}
