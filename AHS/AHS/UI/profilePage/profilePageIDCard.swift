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
            idCardButton.idState = .isUnlocked;
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
        
        //print("signed in with name \(signedInUserData.displayName), email \(signedInUserData.email), and url \(signedInUserData.photoURL)")
        
        //
        
        let profileImageView = UIImageView();
        
        idCardButton.addSubview(profileImageView);
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false;
        
        let profileImageViewSize = idCardButtonHeight * 0.45;
        let profileImageViewPadding = 2*horizontalPadding;
        
        profileImageView.trailingAnchor.constraint(equalTo: idCardButton.trailingAnchor, constant: -profileImageViewPadding).isActive = true;
        profileImageView.topAnchor.constraint(equalTo: idCardButton.topAnchor, constant: profileImageViewPadding).isActive = true;
        
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageViewSize).isActive = true;
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageViewSize).isActive = true;
        
        profileImageView.layer.cornerRadius = profileImageViewSize / 2;
        profileImageView.clipsToBounds = true;
        profileImageView.backgroundColor = BackgroundGrayColor;
        profileImageView.contentMode = .scaleAspectFill;
        profileImageView.isUserInteractionEnabled = false;
        
        profileImageView.layer.borderWidth = 0.2;
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor;
        
        profileImageView.sd_setImage(with: signedInUserData.photoURL);
        
        //
        
        let profileBorderView = UIView();
        
        idCardButton.insertSubview(profileBorderView, at: 0);
        
        profileBorderView.translatesAutoresizingMaskIntoConstraints = false;
        
        let profileBorderViewSize = profileImageViewSize + 3;
        
        profileBorderView.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true;
        profileBorderView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true;
        profileBorderView.widthAnchor.constraint(equalToConstant: profileBorderViewSize).isActive = true;
        profileBorderView.heightAnchor.constraint(equalToConstant: profileBorderViewSize).isActive = true;
        
        profileBorderView.backgroundColor = .white;
        profileBorderView.layer.cornerRadius = profileBorderViewSize / 2;
        profileBorderView.clipsToBounds = true;
        profileBorderView.isUserInteractionEnabled = false;
        
        //
        
        let barcodeImageView = UIImageView();
        
        idCardButton.addSubview(barcodeImageView);
        
        barcodeImageView.translatesAutoresizingMaskIntoConstraints = false;
        
        let barcodeImageViewPadding = 2*horizontalPadding;
        
        barcodeImageView.leadingAnchor.constraint(equalTo: idCardButton.leadingAnchor, constant: barcodeImageViewPadding).isActive = true;
        barcodeImageView.bottomAnchor.constraint(equalTo: idCardButton.bottomAnchor, constant: -barcodeImageViewPadding).isActive = true;
        barcodeImageView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: barcodeImageViewPadding).isActive = true;
        
        if let idString = dataManager.getIDFromStudentEmail(signedInUserData.email ?? ""){
            let barcodeImageViewHeight = idCardButtonHeight - profileImageViewPadding - profileImageViewSize - 2*barcodeImageViewPadding;
            let barcodeImageViewWidth = barcodeImageViewHeight * 3;
            
            barcodeImageView.heightAnchor.constraint(equalToConstant: barcodeImageViewHeight).isActive = true;
            barcodeImageView.widthAnchor.constraint(equalToConstant: barcodeImageViewWidth).isActive = true;
            
            barcodeImageView.contentMode = .scaleAspectFit;
            barcodeImageView.layer.cornerRadius = 3;
            barcodeImageView.clipsToBounds = true;
            barcodeImageView.backgroundColor = .white;
            barcodeImageView.isUserInteractionEnabled = false;
            
            barcodeImageView.image = dataManager.getIDBarcode(idString);
        }
        else{
            print("Invalid student email when attempting to render ID card");
        }
            
        //
        
        let userNameLabel = UILabel();
        
        idCardButton.addSubview(userNameLabel);
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        let userNameLabelPadding = 2*horizontalPadding;
        
        userNameLabel.leadingAnchor.constraint(equalTo: idCardButton.leadingAnchor, constant: userNameLabelPadding).isActive = true;
        userNameLabel.topAnchor.constraint(equalTo: idCardButton.topAnchor, constant: userNameLabelPadding).isActive = true;
        userNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: profileImageView.leadingAnchor, constant: -userNameLabelPadding).isActive = true;
        userNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: barcodeImageView.topAnchor, constant: -userNameLabelPadding).isActive = true;
        
        userNameLabel.text = dataManager.splitFullName(signedInUserData.displayName ?? "");
        userNameLabel.textAlignment = .left;
        userNameLabel.textColor = .white;
        userNameLabel.font = UIFont(name: SFCompactDisplay_Semibold, size: idCardButtonHeight * 0.16);
        userNameLabel.numberOfLines = 0;
        userNameLabel.adjustsFontSizeToFitWidth = true;
        userNameLabel.minimumScaleFactor = 0.3;
        userNameLabel.isUserInteractionEnabled = false;
        
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
