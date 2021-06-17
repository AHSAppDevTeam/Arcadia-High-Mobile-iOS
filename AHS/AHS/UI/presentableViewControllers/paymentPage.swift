//
//  paymentPage.swift
//  AHS
//
//  Created by McMahon Family on 5/26/21.
//

import UIKit

class paymentPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBlue;
        // Do any additional setup after loading the view.
        
        let panGestureRecognizer = UIPanGestureRecognizer();
        panGestureRecognizer.addTarget(self, action: #selector(self.handlePan))
        
        self.view.addGestureRecognizer(panGestureRecognizer);
    }
    
    @objc func handlePan(_ panGestureRecognizer: UIPanGestureRecognizer){
        popTransition.handlePan(panGestureRecognizer, fromViewController: self);
    } 

}
