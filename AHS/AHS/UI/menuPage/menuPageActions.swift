//
//  menuPageActions.swift
//  AHS
//
//  Created by Akshaj Kanumuri on 2/6/25.
//

import Foundation
import UIKit

extension menuPageViewController: UIScrollViewDelegate {
    @objc internal func refresh() {
        loadCalendarData()
        self.renderContent(with: generateSampleMenu())
        self.refreshControl.endRefreshing()
    }

    internal func reload() {
        self.refreshControl.beginRefreshing()
        self.refresh()
    }
    
    @objc internal func endRefreshing() {
        self.refreshControl.endRefreshing()
        self.mainScrollView.setContentOffset(.zero, animated: true)
    }
    
    @objc internal func resetContentOffset() {
        self.mainScrollView.setContentOffset(.zero, animated: true)
    }
}
