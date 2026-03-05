import SwiftUI

enum Appearance: String, CaseIterable {
    case system, light, dark

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }

    var label: String {
        switch self {
        case .system: return "System"
        case .light:  return "Light"
        case .dark:   return "Dark"
        }
    }
}

extension Appearance {
    func resolved(with systemColorScheme: ColorScheme) -> ColorScheme {
        switch self {
        case .system: return systemColorScheme
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}
