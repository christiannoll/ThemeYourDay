//
//  AuthorizationManager.swift
//  ThemeYourDay
//
//  Created by Christian on 05.02.23.
//

import Foundation
import UserNotifications

class AuthorizationManager {
 
    private let notificationCenter: UNUserNotificationCenter
    
    init(notifivationCenter: UNUserNotificationCenter = .current()) {
        self.notificationCenter = notifivationCenter
    }
    
    func currentAuthorization(completion: @escaping (UNAuthorizationStatus) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
    
    func askAuthorization(completionHandler: @escaping (Bool, Error?) -> Void) {
        notificationCenter.requestAuthorization(
            options: [.badge, .sound, .alert],
            completionHandler: completionHandler
        )
    }
}
