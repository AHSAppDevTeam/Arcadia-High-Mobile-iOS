//
//  savedPageSortBy.swift
//  AHS
//
//  Created by Richard Wei on 7/8/21.
//

import Foundation
import UIKit

extension savedPageViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell at \(indexPath.row)");
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedSortingMethods.numberOfEnums();
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: savedPageSortByCell.identifier, for: indexPath) as! savedPageSortByCell;
        
        cell.update(indexPath.row);
        
        return cell;
    }
    
    
}
