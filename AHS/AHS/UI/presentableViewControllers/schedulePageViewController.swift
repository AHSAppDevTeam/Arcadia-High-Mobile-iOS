//
//  schedulePageViewController.swift
//  AHS
//
//  Created by McMahon Family on 5/26/21.
//

import UIKit

class schedulePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemRed;
       
        let panGestureRecognizer = UIPanGestureRecognizer();
        panGestureRecognizer.addTarget(self, action: #selector(self.handlePan));
        
        self.view.addGestureRecognizer(panGestureRecognizer);
    }
    
    @objc func handlePan(_ panGestureRecognizer: UIPanGestureRecognizer){
        popTransition.handlePan(panGestureRecognizer, fromViewController: self);
    }

}
