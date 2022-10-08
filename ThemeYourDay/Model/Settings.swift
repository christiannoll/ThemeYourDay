import Foundation

struct Settings: Hashable, Codable {
    var fgColors = [DayColor()]
    var bgColors = [Day.defaultBgColor]
    var textLineSpacing = 10
    
    var weekdaysBgColor = Array(repeating: Day.defaultBgColor, count: 7)
    var weekdaysFgColor = Array(repeating: DayColor(), count: 7)
    var weekdaysText = WeekdaysText
    
    static let WeekdaysText = Array(["Theme your Sunday", "Theme your Monday", "Theme your Tuesday", "Theme your Wednesday", "Theme your Thursday", "Theme your Friday", "Theme your Saturday"])
}
