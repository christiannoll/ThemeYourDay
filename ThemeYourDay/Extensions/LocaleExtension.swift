import Foundation

extension Locale {

    //public static let dataKey = "language"

    public static var currentLanguage: String? {
        Locale.preferredLanguages.first
    }

    public static var isEnglish: Bool {
        if let lang = Locale.currentLanguage {
            if lang.contains("en") {
                return true
            }
        }
        return false
    }
}
