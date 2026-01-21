import UIKit
import UserNotifications

extension NotificationSettingsView {
    
    class ViewModel: ObservableObject {
        
        @Published var currentAuthorizationStatus: UNAuthorizationStatus
        
        private let authorizationManager = AuthorizationManager()
        private let settingsOpener: SystemSettingsOpener = UIApplication.shared
        
        init() {
            currentAuthorizationStatus = .notDetermined
            refreshAuthorizationStatus()
        }
        
        var isEnableNotificationToggleEnabled: Bool {
            currentAuthorizationStatus == .authorized
        }
        
        var isAskPermissionButtonVisible: Bool {
            currentAuthorizationStatus == .notDetermined
        }
        
        var isOpenSettingsButtonVisible: Bool {
            ![UNAuthorizationStatus.notDetermined, UNAuthorizationStatus.authorized].contains(currentAuthorizationStatus)
        }
        
        var currentStatus: String {
            switch currentAuthorizationStatus {
            case .authorized:
                return "Authorized"
            case .denied:
                return "Denied"
            case .ephemeral:
                return "Ephemeral"
            case .notDetermined:
                return "Not Determined"
            case .provisional:
                return "Provisional"
            @unknown default:
                return "Unknown"
            }
        }
        
        func askPermissions() {
            authorizationManager.askAuthorization { [weak self] success, _ in
                self?.refreshAuthorizationStatus()
            }
        }
        
        func openSettings() {
            settingsOpener.openSettings()
        }
        
        func registerNotificationRequest(settings: Settings) {
            let date = Calendar.current.dateComponents([.hour, .minute], from: settings.notificationSettings.remindAt)
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let content = UNMutableNotificationContent()
            content.title = "Theme your day!"
            content.body =  "Every day is important and special."
            
            let requestId = UUID().uuidString
            let request = UNNotificationRequest(
                identifier: requestId, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error {
                    print(error)
                }
            }
        }
        
        func cancelNotificationRequest() {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
     
        private func refreshAuthorizationStatus() {
            authorizationManager.currentAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    self?.currentAuthorizationStatus = status
                }
            }
        }
    }
}
