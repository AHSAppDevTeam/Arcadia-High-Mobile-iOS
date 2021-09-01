//
//  profilePageTableView.swift
//  AHS
//
//  Created by Richard Wei on 7/9/21.
//

import Foundation
import UIKit

extension profilePageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.openSchedulePage();
        default:
            self.openTableViewPage(indexPath);
        }
    }
    
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // Schedule
            return 1;
        case 1: // Options
            return optionsCellTitles.count;
        case 2: // Info
            return infoCellTitles.count;
        default:
            return 0;
        }
    }
    
    public static func getHeightForSection(_ section: Int) -> CGFloat{
        return section == 0 ? scheduleViewHeight + 2*verticalPadding : contentTableViewRowHeight;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return profilePageViewController.getHeightForSection(indexPath.section);
    }
    
    //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contentTableViewSectionCount;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return profilePageViewController.contentTableViewSectionHeight;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerViewFrame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: profilePageViewController.contentTableViewSectionHeight);
        let headerView = UIView(frame: headerViewFrame);
        
        //
        
        let headerTitleLabelPadding : CGFloat = 0;
        let headerTitleLabelFrame = CGRect(x: headerTitleLabelPadding, y: 0, width: headerView.frame.width - 2*headerTitleLabelPadding, height: headerView.frame.height);
        let headerTitleLabel = UILabel(frame: headerTitleLabelFrame);
        
        headerTitleLabel.text = getHeaderTitle(for: section);
        headerTitleLabel.textAlignment = .left;
        headerTitleLabel.textColor = InverseBackgroundColor;
        headerTitleLabel.font = UIFont(name: SFProDisplay_Bold, size: headerTitleLabel.frame.height * 0.7);
        headerTitleLabel.numberOfLines = 1;
        
        headerView.addSubview(headerTitleLabel);
        
        //

        return headerView;
    }
    
    func getHeaderTitle(for section: Int) -> String{
        var s : String = "";
        switch section {
        case 0:
            s += "Schedule";
        case 1:
            s += "Options";
        case 2:
            s += "Info";
        default:
            s = "";
        }
        return s;
    }
    
    //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: profilePageTableViewCell.identifier, for: indexPath) as! profilePageTableViewCell;
        
        cell.selectionStyle = .none;
        
        if (indexPath.section == 0){
            cell.updateWithView(indexPath.section, scheduleView);
            renderSchedule();
        }
        else{
            cell.updateWithButton(indexPath.section, title: contentTableViewCellTitles[indexPath.section - 1][indexPath.row], value: contentTableViewCellValues[indexPath.section - 1][indexPath.row]);
        }
        
        return cell;
    }
    
}
