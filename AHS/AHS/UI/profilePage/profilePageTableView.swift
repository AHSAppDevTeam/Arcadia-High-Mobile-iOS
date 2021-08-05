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
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: profilePageTableViewCell.identifier, for: indexPath) as! profilePageTableViewCell;
        return cell;
    }
    
}
