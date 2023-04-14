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
    
    static public func getSignedInUserData() -> GIDGoogleUser?{
        //print("[polling whether or not we're signed in]");
        return GIDSignIn.sharedInstance.currentUser;
    }
    
    static public func recoverPreviousSignInSession(){
        //print("[restore previous session called]");
        GIDSignIn.sharedInstance.restorePreviousSignIn(completion: { (user, error) in
            //signInFirebase(user, error: error, completion: { _ in });
            if (user != nil && error == nil){
                // TODO: refresh id card to show signed in state
                //print("[previous session signed in]")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: profilePageIDSignedInNotification), object: nil, userInfo: nil);
            }
        });
    }
    
    static public func signInUser(_ parentVC: UIViewController, completion: @escaping (Error?) -> Void){
        
        //guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        //let config = GIDConfiguration(clientID: clientID);
        
        GIDSignIn.sharedInstance.signIn(withPresenting: parentVC) { (user, error) in
            completion(error);
        }
        
        /*GIDSignIn.sharedInstance.signIn(with: config, presenting: parentVC) { (user, error) in
            /*signInFirebase(user, error: error, completion: { (err) in
                
                completion(err);
                
            });*/
            completion(error);
        }*/
    }
    
    /*static private func signInFirebase(_ user: GIDGoogleUser?, error: Error?, completion: @escaping (Error?) -> Void){ // for signing into firebase
        if let err = error {
            completion(err);
            return;
        }
        
        /*guard let authentication = user?.authentication, let idToken = authentication.idToken else {
            print("Failed to cast auth and idToken on sign in");
            return;
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken);*/
        
        guard let idToken = user?.idToken, let accessToken = user?.accessToken else{
            print("Failed to cast auth and idToken on sign in");
            return;
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString);
        
        Auth.auth().signIn(with: credential, completion: { (authResult, error) in
            
            completion(error);
            
        });
    }*/
    
    static public func signOutUser(){
        /*do{
            try Auth.auth().signOut();
            GIDSignIn.sharedInstance.signOut();
        }
        catch{
            print("Failed to sign out - \(error.localizedDescription)");
        }*/
        GIDSignIn.sharedInstance.signOut();
    }
    
}
