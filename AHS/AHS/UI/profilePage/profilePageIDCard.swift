//
//  profilePageIDCard.swift
//  AHS
//
//  Created by Richard Wei on 8/1/21.
//

import Foundation
import UIKit

import Firebase
import GoogleSignIn

extension profilePageViewController{
    
    @objc internal func handleIDCardPress(){
        
        switch idCardButton.idState {
        case .isLocked:
            print("isLocked state");
        case .isUnlocked:
            createIDActionPrompt();
        case .requiresSignIn:
            dataManager.signInUser(self, completion: { (error) in
                
                if let err = error{
                    print("Error while signing in - \(err.localizedDescription)");
                    return;
                }
                
                self.idCardButton.idState = .isUnlocked;
                self.renderIDCard();
                
            });
        }
        
        renderIDCard();
        
    }
    
    internal func renderIDCard(){
        
        for view in idCardButton.subviews{
            view.removeFromSuperview();
        }
        
        switch idCardButton.idState{
        case .isLocked:
            renderID_Lock();
        case .isUnlocked:
            renderID_Content();
        case .requiresSignIn:
            renderID_SignIn();
        }
    }
    
    private func renderID_Content(){
        
        guard let signedInUserData = dataManager.getSignedInUserData() else{
            print("Sign in is required")
            idCardButton.idState = .requiresSignIn;
            renderIDCard();
            return;
        }
        
        //
        
        print("signed in with name \(signedInUserData.displayName), email \(signedInUserData.email), and url \(signedInUserData.photoURL)")
        
        
    }
    
    private func renderID_SignIn(){
        
        let signInIconImageView = UIImageView();
        
        idCardButton.addSubview(signInIconImageView);
        
        signInIconImageView.translatesAutoresizingMaskIntoConstraints = false;
        
        signInIconImageView.centerXAnchor.constraint(equalTo: idCardButton.centerXAnchor).isActive = true;
        signInIconImageView.centerYAnchor.constraint(equalTo: idCardButton.centerYAnchor).isActive = true;
        
        let signInIconImageViewSize = idCardButtonHeight * 0.2;
        
        signInIconImageView.widthAnchor.constraint(equalToConstant: signInIconImageViewSize).isActive = true;
        signInIconImageView.heightAnchor.constraint(equalToConstant: signInIconImageViewSize).isActive = true;
        
        signInIconImageView.image = UIImage(named: "google-icon");
        signInIconImageView.contentMode = .scaleAspectFit;
        
        //
        
        let signInLabel = UILabel();
        
        idCardButton.addSubview(signInLabel);
        
        signInLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        signInLabel.centerXAnchor.constraint(equalTo: idCardButton.centerXAnchor).isActive = true;
        signInLabel.topAnchor.constraint(equalTo: signInIconImageView.bottomAnchor, constant: verticalPadding).isActive = true;
        
        signInLabel.text = "Sign-In";
        signInLabel.textAlignment = .center;
        signInLabel.textColor = .white;
        signInLabel.font = UIFont(name: SFProDisplay_Semibold, size: idCardButtonWidth * 0.035);
        
    }
    
    private func renderID_Lock(){
        
        let lockIconImageView = UIImageView();
        
        idCardButton.addSubview(lockIconImageView);
        
        lockIconImageView.translatesAutoresizingMaskIntoConstraints = false;
        
        lockIconImageView.centerXAnchor.constraint(equalTo: idCardButton.centerXAnchor).isActive = true;
        lockIconImageView.centerYAnchor.constraint(equalTo: idCardButton.centerYAnchor).isActive = true;
        
        let lockIconImageViewSize = idCardButtonHeight * 0.2;
        
        lockIconImageView.widthAnchor.constraint(equalToConstant: lockIconImageViewSize).isActive = true;
        lockIconImageView.heightAnchor.constraint(equalToConstant: lockIconImageViewSize).isActive = true;
        
        lockIconImageView.image = UIImage(systemName: "lock.fill");
        lockIconImageView.tintColor = .white;
        lockIconImageView.contentMode = .scaleAspectFit;
        
        //
        
        let lockLabel = UILabel();
        
        idCardButton.addSubview(lockLabel);
        
        lockLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        lockLabel.centerXAnchor.constraint(equalTo: idCardButton.centerXAnchor).isActive = true;
        lockLabel.topAnchor.constraint(equalTo: lockIconImageView.bottomAnchor, constant: verticalPadding).isActive = true;
        
        lockLabel.text = "Tap to unlock";
        lockLabel.textAlignment = .center;
        lockLabel.textColor = .white;
        lockLabel.font = UIFont(name: SFProDisplay_Semibold, size: idCardButtonWidth * 0.035);
        
    }
    
    //
    
    private func createIDActionPrompt(){
        
        let confirmPopUp = UIAlertController(title: title, message: "ID Card", preferredStyle: .actionSheet);

        confirmPopUp.addAction(UIAlertAction(title: "Lock", style: .default, handler: { (_) in
            self.idCardButton.idState = .isLocked;
            self.renderIDCard();
        }));
        
        confirmPopUp.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.idCardButton.idState = .requiresSignIn;
        
            dataManager.signOutUser();
            
            self.renderIDCard();
        }));
        
        self.present(confirmPopUp, animated: true);
        
    }
    
}
