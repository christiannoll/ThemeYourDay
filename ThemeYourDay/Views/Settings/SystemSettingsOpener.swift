//
//  SystemSettingsOpener.swift
//  ThemeYourDay
//
//  Created by Christian on 05.02.23.
//

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
