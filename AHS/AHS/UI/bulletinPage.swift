//
//  bulletinPage.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

class bulletinPageViewController : mainPageViewController{
    
    init(){
        super.init(nibName: nil, bundle: nil);
        self.pageName = "Student";
        self.secondaryPageName = "Bulletin";
        self.viewControllerIconName = "doc.plaintext.fill";
    }
    
    required init?(coder: NSCoder) { // required uiviewcontroller init
        super.init(coder: coder);
    }
    
    //
    
    internal let mainScrollView : UIScrollView = UIScrollView();

    internal let categoryScrollView : UIScrollView = UIScrollView();
    
    internal let comingUpLabel : UILabel = UILabel();
    internal let comingUpContentView : UIView = UIView();
    
    internal let bulletinContentView : UIView = UIView();
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if (!self.hasBeenSetup){
            
            mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
            self.view.addSubview(mainScrollView);
            
            self.renderLayout();
            
            self.hasBeenSetup = true;
        }
        
    }
    
    internal func renderLayout(){
        
        
        
    }
}

