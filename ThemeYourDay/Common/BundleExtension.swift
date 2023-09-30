//
//  BundleExtension.swift
//  ThemeYourDay
//
//  Created by Christian on 30.09.23.
//

import Foundation

public extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var versionNumberWithBuild: String? {
        guard let releaseVersionNumber, let buildVersionNumber else {
            return nil
        }
        return "\(releaseVersionNumber) (\(buildVersionNumber))"
    }
}
