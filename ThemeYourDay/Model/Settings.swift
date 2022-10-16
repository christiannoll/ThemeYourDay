import Foundation

struct Settings: Hashable, Codable {
    var fgColors = [DayColor()]
    var bgColors = [Day.defaultBgColor,
                    DayColor(r: 249/255, g: 226/255, b: 49/255, a: 1.0),
                    DayColor(r: 237/255, g: 35/255, b: 13/255, a: 1.0),
                    DayColor(r: 96/255, g: 216/255, b: 56/255, a: 1.0),
                    DayColor(r: 173/255, g: 173/255, b: 173/255, a: 1.0)]
    var textLineSpacing = 10
    
    var weekdaysBgColor = Array(repeating: Day.defaultBgColor, count: 7)
    var weekdaysFgColor = Array(repeating: DayColor(), count: 7)
    var weekdaysText = WeekdaysText
    
    static let WeekdaysText = Array(["Theme your Sunday", "Theme your Monday", "Theme your Tuesday", "Theme your Wednesday", "Theme your Thursday", "Theme your Friday", "Theme your Saturday"])
}
