//
//  savedPageSortBy.swift
//  AHS
//
//  Created by Richard Wei on 7/8/21.
//

import Foundation
import UIKit
import AudioToolbox

extension savedPageViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred();
        dataManager.preferencesStruct.savedArticlesSortPreference = savedSortingMethods.methodFromIndex(indexPath.row);
        sortByPopTip.hide();
        reload();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedSortingMethods.numberOfEnums();
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: savedPageSortByCell.identifier, for: indexPath) as! savedPageSortByCell;
        cell.selectionStyle = .none;
        
        cell.update(indexPath.row, cellHeight);
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded();
    }
    
}
