//
//  Miscellaneous.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

// Colors

// General
let mainThemeColor = UIColor(named: "mainThemeColor")!;
let InverseBackgroundColor = UIColor(named: "InverseBackgroundColor")!;
let InverseBackgroundGrayColor = UIColor(named: "InverseBackgroundGrayColor")!;
let BackgroundGrayColor = UIColor(named: "BackgroundGrayColor")!;
let BackgroundSecondaryGrayColor = UIColor(named: "BackgroundSecondaryGrayColor")!;
let BackgroundColor = UIColor(named: "BackgroundColor")!;
let dull_mainThemeColor = UIColor(named: "dull_mainThemeColor")!;
let dull_BackgroundColor = UIColor(named: "dull_BackgroundColor")!;

let timestampLabelTextPrefix = " ∙ ";

// Navigation Bar
let NavigationBarColor = UIColor(named: "NavigationBarColor")!;

// Navigation Button
let NavigationButtonUnselectedColor = UIColor(named: "NavigationButtonUnselectedColor")!;
let NavigationButtonSelectedColor = UIColor(named: "NavigationButtonSelectedColor")!;
//

// Fonts
let SFProDisplay_Bold = "SFProDisplay-Bold";
let SFProDisplay_Regular = "SFProDisplay-Regular";
let SFProDisplay_Semibold = "SFProDisplay-Semibold";
let SFProDisplay_Black = "SFProDisplay-Black";
let SFProDisplay_Light = "SFProDisplay-Light";
let SFProDisplay_Medium = "SFProDisplay-Medium";
let SFCompactDisplay_Light = "SFCompactDisplay-Light";
let SFCompactDisplay_Semibold = "SFCompactDisplay-Semibold";
//

// Global constants
let homePageHorizontalPadding = AppUtility.getCurrentScreenSize().width / 20;
//

// Notification Center Macros
let articlePageNotification = "articlePageNotification";
let categoryPageNotification = "categoryPageNotification";

let profilePageContentNotification = "profilePageContentNotification";

let setScrollViewZeroContentOffset = "setScrollViewZeroContentOffset";

let homePageRefreshNotification = "homePageRefreshNotification";
let homePageEndRefreshing = "homePageEndRefreshing";
let homePageBeginRefreshing = "homePageBeginRefreshing";

let endDataManagerRefreshing = "endDataManagerRefreshing";

//

// Misc functions

func createConfirmationPrompt(_ viewController: UIViewController, _ title: String, confirmCompletion: @escaping () -> Void, declineCompletion: @escaping () -> Void = { () in }){
    
    let confirmPopUp = UIAlertController(title: title, message: "Are you sure?", preferredStyle: .actionSheet);
    
    confirmPopUp.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
        
        confirmCompletion();
        
    }));
     
    confirmPopUp.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (_) in
        
        declineCompletion();
        
    }));
    
    viewController.present(confirmPopUp, animated: true);
    
}
