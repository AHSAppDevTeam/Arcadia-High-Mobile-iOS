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
        
        let index = indexPath.row;
        
        if (index < savedSortingStruct.numberOfOptions()){ // options
            
            let cell = tableView.cellForRow(at: indexPath) as! savedPageSortByCell;
            
            dataManager.preferencesStruct.savedArticlesSortPreference.updateOptionWithIndex(index, cell.updateOptions());
            
        }
        else{
            dataManager.preferencesStruct.savedArticlesSortPreference.sortingMethod = savedSortingStruct.savedSortingMethods.methodFromIndex(index - savedSortingStruct.numberOfOptions());
            sortByPopTip.hide();
            reload();
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedSortingStruct.numberOfCells();
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: savedPageSortByCell.identifier, for: indexPath) as! savedPageSortByCell;
        cell.selectionStyle = .none;
        
        let index = indexPath.row;
        
        if (index < savedSortingStruct.numberOfOptions()){
            cell.renderOption(index, cellHeight);
        }
        else{
            cell.renderMethod(index - savedSortingStruct.numberOfOptions(), cellHeight);
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded();
    }
    
}
