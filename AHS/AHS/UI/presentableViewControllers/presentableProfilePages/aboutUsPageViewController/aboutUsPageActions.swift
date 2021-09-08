//
//  aboutUsPageActions.swift
//  AHS
//
//  Created by Richard Wei on 9/3/21.
//

import Foundation
import UIKit

extension aboutUsPageViewController{
    
    @objc internal func refresh(_ refreshControl: UIRefreshControl){
        //print("refresh");
        loadCreditsList();
    }
    
    @objc internal func handleBackButton(_ button: UIButton){
        self.dismiss(animated: true);
    }
    
}
