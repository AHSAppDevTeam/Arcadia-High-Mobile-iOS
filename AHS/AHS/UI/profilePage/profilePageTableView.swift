//
//  profilePageTableView.swift
//  AHS
//
//  Created by Richard Wei on 7/9/21.
//

import Foundation
import UIKit

extension profilePageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoButtonTitlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: infoTableViewCell.identifier, for: indexPath) as! infoTableViewCell;
        cell.buttonTitle.text = infoButtonTitlesArray[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        print(row)
        var vc : UIViewController? = nil;
        
        switch row {
        case 0:
            vc = aboutUsPageViewController();
        case 2:
            vc = termsAndAgreementsPageViewController();
        default:
            vc = nil;
        }
        
        // case 1 was removed because we don't need an entire page for the app verison. You can just have a label that tells the app version instead.
        
        guard let presentedVC = vc else{
            return;
        }
        
        transitionDelegateVar = transitionDelegate();
        presentedVC.transitioningDelegate = transitionDelegateVar;
        presentedVC.modalPresentationStyle = .custom;
        
        
        self.present(presentedVC, animated: true);
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
