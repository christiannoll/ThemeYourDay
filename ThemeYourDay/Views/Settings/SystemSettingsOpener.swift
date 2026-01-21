import UIKit

protocol SystemSettingsOpener {
    func openSettings()
}

extension UIApplication: SystemSettingsOpener {
    func openSettings() {
        guard
            let url = URL(string: UIApplication.openSettingsURLString+Bundle.main.bundleIdentifier!),
            self.canOpenURL(url)
        else {
            return
        }
        
        self.open(url, options: [:])
    }
}
