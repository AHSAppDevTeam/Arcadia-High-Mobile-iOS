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
    
    @objc internal func handleNFCBuffering(){
        DispatchQueue.main.sync {
            showIDBuffering();
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.initNFC();
            }
        }
    }
    
    @objc internal func showIDBuffering(){
        self.idCardButton.idState = .isBuffering;
        for subview in self.idCardButton.subviews{
            if (subview.tag == 1){
                subview.isHidden = true;
            }
            else if (subview.tag == 2){
                if let loadingView = subview as? UIActivityIndicatorView{
                    loadingView.isHidden = false;
                    loadingView.startAnimating();
                }
            }
        }
    }
    
    @objc internal func hideIDBuffering(){
        self.idCardButton.idState = .isUnlocked;
        for subview in self.idCardButton.subviews{
            if (subview.tag == 1){
                subview.isHidden = false;
            }
            else if (subview.tag == 2){
                if let loadingView = subview as? UIActivityIndicatorView{
                    loadingView.stopAnimating();
                    loadingView.isHidden = true;
                }
            }
        }
    }
    
    //
    
    @objc internal func initNFC(){
        UIImpactFeedbackGenerator(style: .medium).impactOccurred();
        showIDBuffering();
        nfcmgr.initNFC();
    }
    
    @objc internal func handleIDCardPress(){
        
        //handleNFCBuffering();
        if (idCardButton.idState != .isBuffering){
            if (idCardButton.idState != .isUnlocked || !dataManager.getIsStudentSignedIn()){
                if (idCardButton.idState == .isLocked){
                    authmgr.authenticate(self, completion: { err in
                        if (err == nil){
                            self.idCardButton.idState = .isUnlocked;
                            DispatchQueue.main.async {
                                self.renderIDCard();
                            }
                        }
                    });
                }
                else{
                    handleIDCardLongPress();
                }
            }
            else{
                //print("nfc triggered \(idstr)");
                initNFC();
            }
        }
        
    }
    
    @objc internal func handleIDCardLongPress(){
        if (idCardButton.idState != .isBuffering){
            switch idCardButton.idState {
            case .isLocked:
                createRestrictedIDActionPrompt();
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
            case .isBuffering:
                print("invalid call to handleIDCardLongPress");
                break;
            }
            
            renderIDCard();
        }
    }
    
    //
    
    @objc internal func renderIDCard(){
                        
        for view in idCardButton.subviews{
            view.removeFromSuperview();
        }
        
        dataManager.saveIDLockedState(self.idCardButton);
        
        switch idCardButton.idState{
        case .isLocked:
            renderID_Lock();
        case .isUnlocked:
            renderID_Content();
        case .requiresSignIn:
            renderID_SignIn();
        case .isBuffering:
            print("invalid call to renderIDCard");
            break;
        }
    }
    
    private func renderID_Content(){
        
        guard let signedInUserData = dataManager.getSignedInUserData() else{
            print("Sign in is required");
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
        let profileImageViewPadding = 2*profilePageViewController.horizontalPadding;
        
        profileImageView.trailingAnchor.constraint(equalTo: idCardButton.trailingAnchor, constant: CGFloat(-profileImageViewPadding)).isActive = true;
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
        
        let profileImageURL = signedInUserData.profile?.imageURL(withDimension: UInt(round(profileImageViewSize * UIScreen.main.scale)));
        profileImageView.sd_setImage(with: profileImageURL);
        
        //
        
        let profileBorderView = UIView();
        
        idCardButton.insertSubview(profileBorderView, belowSubview: profileImageView);
        
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
        
        let userNameLabel = UILabel();
        
        idCardButton.addSubview(userNameLabel);
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        let userNameLabelPadding = 2*profilePageViewController.horizontalPadding;
        
        userNameLabel.leadingAnchor.constraint(equalTo: idCardButton.leadingAnchor, constant: userNameLabelPadding).isActive = true;
        userNameLabel.topAnchor.constraint(equalTo: idCardButton.topAnchor, constant: userNameLabelPadding).isActive = true;
        userNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: profileImageView.leadingAnchor, constant: CGFloat(-userNameLabelPadding)).isActive = true;
        //userNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: barcodeImageView.topAnchor, constant: -userNameLabelPadding).isActive = true;
        
        userNameLabel.text = dataManager.splitFullName(signedInUserData.profile?.name ?? "");
        userNameLabel.textAlignment = .left;
        userNameLabel.textColor = .white;
        userNameLabel.font = UIFont(name: SFCompactDisplay_Semibold, size: idCardButtonHeight * 0.16);
        userNameLabel.numberOfLines = 0;
        userNameLabel.adjustsFontSizeToFitWidth = true;
        userNameLabel.minimumScaleFactor = 0.3;
        userNameLabel.isUserInteractionEnabled = false;
        
        //
        
        if let idString = dataManager.getIDFromStudentEmail(signedInUserData.profile?.email ?? ""){
            
            //print("valid id = " + idString);
           
            let nfcLabel = UILabel();
            let nfcLabelText = "Tap for NFC"
            let nfcLabelFont = UIFont(name: SFProDisplay_Bold, size: idCardButtonHeight * 0.075)!;
            let nfcLabelHeight = nfcLabelText.height(withConstrainedWidth: idCardButtonWidth, font: nfcLabelFont);
            
            nfcLabel.tag = 1;
            
            idCardButton.addSubview(nfcLabel);
            
            nfcLabel.translatesAutoresizingMaskIntoConstraints = false;
            
            nfcLabel.centerXAnchor.constraint(equalTo: idCardButton.centerXAnchor).isActive = true;
            nfcLabel.bottomAnchor.constraint(equalTo: idCardButton.bottomAnchor, constant: -idCardButtonHeight * 0.05).isActive = true;
            nfcLabel.leadingAnchor.constraint(equalTo: idCardButton.leadingAnchor).isActive = true;
            nfcLabel.trailingAnchor.constraint(equalTo: idCardButton.trailingAnchor).isActive = true;
            
            nfcLabel.text = nfcLabelText;
            nfcLabel.font = nfcLabelFont;
            nfcLabel.textAlignment = .center;
            nfcLabel.textColor = .white;
            
            
            //
            
            let nfcImageView = UIImageView();
            let nfcImageViewSize = idCardButtonWidth * 0.16;
            
            nfcImageView.tag = 1;
            
            idCardButton.addSubview(nfcImageView);
            
            nfcImageView.translatesAutoresizingMaskIntoConstraints = false;
            
            nfcImageView.centerXAnchor.constraint(equalTo: idCardButton.centerXAnchor).isActive = true;
            nfcImageView.bottomAnchor.constraint(equalTo: nfcLabel.topAnchor, constant: -idCardButtonHeight * 0.03).isActive = true;
            nfcImageView.topAnchor.constraint(greaterThanOrEqualTo: profileImageView.bottomAnchor).isActive = true;
            nfcImageView.widthAnchor.constraint(equalToConstant: nfcImageViewSize).isActive = true;
            nfcImageView.heightAnchor.constraint(equalToConstant: nfcImageViewSize).isActive = true;
            
            nfcImageView.tintColor = .white;
            nfcImageView.image = UIImage(systemName: "wave.3.forward.circle.fill");
            //nfcImageView.backgroundColor = .systemRed;
            
            //
            
            let idLabel = UILabel();
            
            idCardButton.addSubview(idLabel);
            
            idLabel.translatesAutoresizingMaskIntoConstraints = false;
            
            let idLabelPadding = 2*profilePageViewController.horizontalPadding;
            
            idLabel.leadingAnchor.constraint(equalTo: idCardButton.leadingAnchor, constant: idLabelPadding).isActive = true;
            idLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: idLabelPadding * 0.2).isActive = true;
            idLabel.trailingAnchor.constraint(lessThanOrEqualTo: profileImageView.leadingAnchor, constant: CGFloat(-idLabelPadding)).isActive = true;
            
            idLabel.text = idString;
            idLabel.textAlignment = .left;
            idLabel.textColor = .white;
            idLabel.font = UIFont(name: SFCompactDisplay_Semibold, size: idCardButtonHeight * 0.1);
            
            //
            
            let loadingView = UIActivityIndicatorView();
            loadingView.tag = 2;
            loadingView.isHidden = true;
            idCardButton.addSubview(loadingView);
            
            loadingView.translatesAutoresizingMaskIntoConstraints = false;
            
            loadingView.centerXAnchor.constraint(equalTo: idCardButton.centerXAnchor).isActive = true;
            loadingView.bottomAnchor.constraint(equalTo: idCardButton.bottomAnchor, constant: -35).isActive = true;
        
           // loadingView.startAnimating();
            
        }
        else{
            //print("Invalid student email when attempting to render ID card");
            
            let invalidLabel = UILabel();
            let invalidLabelText = "Not a student";
            let invalidLabelFont = UIFont(name: SFProDisplay_Bold, size: idCardButtonHeight * 0.11)!;
            let invalidLabelHeight = invalidLabelText.height(withConstrainedWidth: idCardButtonWidth, font: invalidLabelFont);
            
            idCardButton.addSubview(invalidLabel);
            
            invalidLabel.translatesAutoresizingMaskIntoConstraints = false;
            
            invalidLabel.centerXAnchor.constraint(equalTo: idCardButton.centerXAnchor).isActive = true;
            invalidLabel.bottomAnchor.constraint(equalTo: idCardButton.bottomAnchor, constant: -idCardButtonHeight * 0.05).isActive = true;
            invalidLabel.leadingAnchor.constraint(equalTo: idCardButton.leadingAnchor).isActive = true;
            invalidLabel.trailingAnchor.constraint(equalTo: idCardButton.trailingAnchor).isActive = true;
            invalidLabel.heightAnchor.constraint(equalToConstant: invalidLabelHeight).isActive = true;
            
            //invalidLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true;
            //invalidLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true;
            
            invalidLabel.text = invalidLabelText;
            invalidLabel.textAlignment = .center;
            invalidLabel.font = invalidLabelFont;
            //invalidLabel.backgroundColor = .systemRed;
            
        }
        
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
        signInLabel.topAnchor.constraint(equalTo: signInIconImageView.bottomAnchor, constant: profilePageViewController.verticalPadding).isActive = true;
        
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
        lockLabel.topAnchor.constraint(equalTo: lockIconImageView.bottomAnchor, constant: profilePageViewController.verticalPadding).isActive = true;
        
        lockLabel.text = "Tap to unlock";
        lockLabel.textAlignment = .center;
        lockLabel.textColor = .white;
        lockLabel.font = UIFont(name: SFProDisplay_Semibold, size: idCardButtonWidth * 0.035);
        
    }
    
    //
    
    private func createIDActionPrompt(){
        
        let confirmPopUp = UIAlertController(title: title, message: "ID Card", preferredStyle: .actionSheet);
        
        confirmPopUp.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in }));
        
        confirmPopUp.addAction(UIAlertAction(title: "Lock", style: .default, handler: { (_) in
            self.idCardButton.idState = .isLocked;
            dataManager.saveIDLockedState(self.idCardButton);
            self.renderIDCard();
        }));
        
        confirmPopUp.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.idCardButton.idState = .requiresSignIn;
            
            dataManager.signOutUser();
            
            self.renderIDCard();
        }));
        
        self.present(confirmPopUp, animated: true);
        
    }
    
    //
    
    private func createRestrictedIDActionPrompt(){
        
        let confirmPopUp = UIAlertController(title: title, message: "ID Card", preferredStyle: .actionSheet);
        
        confirmPopUp.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in }));
        
        confirmPopUp.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.idCardButton.idState = .requiresSignIn;
            
            dataManager.signOutUser();
            
            self.renderIDCard();
        }));
        
        self.present(confirmPopUp, animated: true);
        
    }
    
}
