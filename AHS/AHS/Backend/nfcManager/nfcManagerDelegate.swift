//
//  nfcManagerDelegate.swift
//  AHS
//
//  Created by Richard Wei on 7/22/22.
//

import Foundation
import CryptoKit
import CoreNFC
import UIKit

extension nfcManager : NFCNDEFReaderSessionDelegate{
    internal func tagRemovalDetect(_ tag: NFCNDEFTag) {
        // In the tag removal procedure, you connect to the tag and query for
        // its availability. You restart RF polling when the tag becomes
        // unavailable; otherwise, wait for certain period of time and repeat
        // availability checking.
        self.nfcSession?.connect(to: tag) { (error: Error?) in
            if error != nil || !tag.isAvailable {
                
                print("Restarting NFC polling");
                
                self.nfcSession?.restartPolling();
                return;
            }
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .milliseconds(500), execute: {
                self.tagRemovalDetect(tag);
            })
        }
    }
    
    private func writeDataToTag(_ session: NFCNDEFReaderSession, _ nfctag: NFCNDEFTag, _ nfcmsg: NFCNDEFMessage){
        // When a tag is read-writable and has sufficient capacity,
        // write an NDEF message to it.
        //print("WRITE TO TAG = \(nfcmsg)");
        nfctag.writeNDEF(nfcmsg) { (error: Error?) in
            if let err = error {
                print("ERROR WRITING TO TAG \(err)");
                session.invalidate(errorMessage: "Update tag failed. Please try again.");
            }
            else{
                session.alertMessage = "Student ID Sent!";
                session.invalidate();
            }
        }
    }
    
    //
    
    internal func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: profilePageIDNFCSuccessNotification), object: nil, userInfo: nil);
        }
    }
    
    internal func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        // If necessary, you may handle the error. Note session is no longer valid.
        // You must create a new session to restart RF polling.
        guard let err = error as? NFCReaderError else{
            print(error);
            return;
        }
        if (err.errorCode != 200){ // error code 200 is "Session invalidated by user"
            print("NFC session invalid BY USER \(err)");
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: profilePageIDNFCBufferingNotification), object: nil, userInfo: nil);
        }
        session.invalidate();
    }
    
    internal func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // no code is placed here, function is not called
        // when you provide `reader(_:didDetect:)` VVV
    }
    
    internal func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        if tags.count > 1 {
            session.alertMessage = "More than 1 NFC tag found. Please present only 1 NFC tag.";
            self.tagRemovalDetect(tags.first!);
            return;
        }
        
        let nfctag = tags.first!;
        session.connect(to: nfctag) { (error: Error?) in
            if let err = error {
                print("Error connecting to tag \(err), restarting...");
                session.restartPolling();
                return;
            }
            
            guard let nfcmsg = self.nfcMessage else{
                session.invalidate(errorMessage: "nfcMessage was not defined yet");
                return;
            }
            
            //print("CONNECTED SESSION")
            
            // You then query the NDEF status of tag.
            nfctag.queryNDEFStatus() { (status: NFCNDEFStatus, capacity: Int, error: Error?) in
                if error != nil {
                    session.invalidate(errorMessage: "Fail to determine NDEF status.  Please try again.");
                    return;
                }
                
                //print("CONNECTED NDEF STATUS = \(status)")
                
                if status == .readOnly {
                    session.invalidate(errorMessage: "Tag is not writable.");
                } else if status == .readWrite {
                    if nfcmsg.length > capacity {
                        session.invalidate(errorMessage: "Tag capacity is too small.  Minimum size requirement is \(nfcmsg.length) bytes.");
                        return;
                    }
                    
                    //print("WRITING TO TAG");
                    self.writeDataToTag(session, nfctag, nfcmsg);
                    
                } else {
                    session.invalidate(errorMessage: "Tag is not NDEF formatted.");
                }
            }
        }
        
        
    }
}

