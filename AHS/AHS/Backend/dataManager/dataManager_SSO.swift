//
//  dataManager_SSO.swift
//  AHS
//
//  Created by Richard Wei on 8/2/21.
//

import Foundation
import Firebase
import GoogleSignIn
import UIKit

extension dataManager{
    
    static public func getSignedInUserData() -> User?{
        return Auth.auth().currentUser;
    }
    
    static public func recoverPreviousSignInSession(){
        GIDSignIn.sharedInstance.restorePreviousSignIn(callback: { (user, error) in
            signInFirebase(user, error: error, completion: { _ in });
        });
    }
    
    static public func signInUser(_ parentVC: UIViewController, completion: @escaping (Error?) -> Void){
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: parentVC) { (user, error) in
            signInFirebase(user, error: error, completion: { (err) in
                
                completion(err);
                
            });
        }
    }
    
    static private func signInFirebase(_ user: GIDGoogleUser?, error: Error?, completion: @escaping (Error?) -> Void){
        if let err = error {
            completion(err);
            return;
        }
        
        guard let authentication = user?.authentication, let idToken = authentication.idToken else {
            
            return;
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken);
        
        Auth.auth().signIn(with: credential, completion: { (authResult, error) in
            
            completion(error);
            
        });
    }
    
    static public func signOutGoogleUser(){
        do{
            try Auth.auth().signOut();
            GIDSignIn.sharedInstance.signOut();
        }
        catch{
            print("Failed to sign out - \(error.localizedDescription)");
        }
    }
    
}
