//
//  AppDelegateMessaging.swift
//  AHS
//
//  Created by Richard Wei on 7/30/21.
//

import Foundation
import Firebase
import FirebaseMessaging

// MARK: FIREBASE HANDLING MESSAGES
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) { // handle regularly
        completionHandler([[.banner, .list, .sound]]) // change presentation style
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) { // handle tapping on notification
        let userInfo = response.notification.request.content.userInfo;
        
        print("userInfo - \(userInfo)");
        
        if let id = userInfo["articleID"] as? String{
            /*dataManager.loadAllArticles(completion: { (isConnected, data) in
             if (isConnected){
             if (data!.articleID == id){
             let articleDataDict: [String: articleData] = ["articleContent" : data!];
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "article"), object: nil, userInfo: articleDataDict);
             }
             }
             });
             notificationFuncClass.loadNotifPref();
             notificationsClass.notificationReadDict[id] = true;
             notificationFuncClass.saveNotifPref(filter: false);*/
        }
        else{
            print("Failed to cast articleID as String");
        }
        
        completionHandler();
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        // sub to notifications
        
        dataManager.updateFirebaseMessagingSubscription();
        
        //
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
