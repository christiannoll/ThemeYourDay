import Foundation
import SwiftData

@Model
final class NotificationSettings {
    var notificationEnabledByUser: Bool
    var remindAt: Date
    
    init(notificationEnabledByUser: Bool, remindAt: Date) {
        self.notificationEnabledByUser = notificationEnabledByUser
        self.remindAt = remindAt
    }
}

@Model
final class Settings {
    
    var fgColors: [DayColor]
    var bgColors: [DayColor]
    var textLineSpacing: Int
    var weekdaysBgColor: [DayColor]
    var weekdaysFgColor: [DayColor]
    var weekdaysText: [String]
    var notificationSettings: NotificationSettings
    
    static let WeekdaysText = Array(["Theme your Sunday", "Theme your Monday", "Theme your Tuesday", "Theme your Wednesday", "Theme your Thursday", "Theme your Friday", "Theme your Saturday"])
    
    init(fgColors: [DayColor] = [DayColor(),
                                 DayColor(r: 55/255, g: 26/255, b: 148/255, a: 1.0),
                                 DayColor(r: 249/255, g: 226/255, b: 49/255, a: 1.0),
                                 DayColor(r: 78/255, g: 122/255, b: 39/255, a: 1.0),
                                 DayColor(r: 152/255, g: 42/255, b: 188/255, a: 1.0)],
         bgColors: [DayColor] = [Day.defaultBgColor,
                                 DayColor(r: 249/255, g: 226/255, b: 49/255, a: 1.0),
                                 DayColor(r: 237/255, g: 35/255, b: 13/255, a: 1.0),
                                 DayColor(r: 96/255, g: 216/255, b: 56/255, a: 1.0),
                                 DayColor(r: 173/255, g: 173/255, b: 173/255, a: 1.0)],
         textLineSpacing: Int = 10,
         weekdaysBgColor: [DayColor] = Array(repeating: Day.defaultBgColor, count: 7),
         weekdaysFgColor: [DayColor] = Array(repeating: DayColor(), count: 7),
         weekdaysText: [String] = WeekdaysText,
         notificationSettings: NotificationSettings = NotificationSettings(notificationEnabledByUser: false, remindAt: Date())) {
        self.fgColors = fgColors
        self.bgColors = bgColors
        self.textLineSpacing = textLineSpacing
        self.weekdaysBgColor = weekdaysBgColor
        self.weekdaysFgColor = weekdaysFgColor
        self.weekdaysText = weekdaysText
        self.notificationSettings = notificationSettings
    }
}
