//
//  NotificationSettingsViewModel.swift
//  ThemeYourDay
//
//  Created by Christian on 05.02.23.
//

import UserNotifications

extension NotificationSettingsView {
    
    class ViewModel: ObservableObject {
        
        @Published var currentAuthorizationStatus: UNAuthorizationStatus
        
        init() {
            currentAuthorizationStatus = .notDetermined
        }
        
        var isEnableNotificationToggleEnabled: Bool {
            currentAuthorizationStatus == .authorized
        }
        
    }
}
