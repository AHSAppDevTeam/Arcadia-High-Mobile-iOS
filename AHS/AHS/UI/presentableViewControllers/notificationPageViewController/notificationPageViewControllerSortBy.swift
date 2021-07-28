//
//  notificationPageViewControllerSortBy.swift
//  AHS
//
//  Created by Richard Wei on 7/27/21.
//

import Foundation
import UIKit

extension notificationPageViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell();
    }
    
    
}
