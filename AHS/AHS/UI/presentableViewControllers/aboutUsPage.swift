//
//  aboutUsPage.swift
//  AHS
//
//  Created by McMahon Family on 6/14/21.
//

import UIKit

class aboutUsPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemRed;
        // Do any additional setup after loading the view.
        
        let panGestureRecognizer = UIPanGestureRecognizer();
        panGestureRecognizer.addTarget(self, action: #selector(self.handlePan))
        
        self.view.addGestureRecognizer(panGestureRecognizer);
    }
    
    @objc func handlePan(_ panGestureRecognizer: UIPanGestureRecognizer){
        popTransition.handlePan(panGestureRecognizer, fromViewController: self);
    }
 
}
