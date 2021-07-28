//
//  notificationPageViewControllerSortBy.swift
//  AHS
//
//  Created by Richard Wei on 7/27/21.
//

import Foundation
import UIKit

extension notificationPageViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred();
        
        let index = indexPath.row;
        
        if (index < notificationSortingStruct.numberOfOptions()){ // options
            
            let cell = tableView.cellForRow(at: indexPath) as! notificationPageSortByCell;
            
            dataManager.preferencesStruct.notificationsSortPreference.updateOptionWithIndex(index, cell.updateOptions());
            
        }
        else{
            dataManager.preferencesStruct.notificationsSortPreference.sortingMethod = notificationSortingStruct.notificationSortingMethods.methodFromIndex(index - notificationSortingStruct.numberOfOptions());
            sortByPopTip.hide();
            reload();
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationSortingStruct.numberOfCells();
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: notificationPageSortByCell.identifier, for: indexPath) as! notificationPageSortByCell;
        cell.selectionStyle = .none;
        cell.backgroundColor = BackgroundColor;
        
        let index = indexPath.row;
        
        if (index < notificationSortingStruct.numberOfOptions()){
            cell.renderOption(index, cellHeight);
        }
        else{
            cell.renderMethod(index - notificationSortingStruct.numberOfOptions(), cellHeight);
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded();
    }
    
}
