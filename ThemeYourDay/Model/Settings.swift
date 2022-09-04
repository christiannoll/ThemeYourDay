import Foundation

struct Settings: Hashable, Codable {
    var fgColors: [DayColor]
    var bgColors: [DayColor]
    var textLineSpacing = 20
    
    var weekdaysBgColor = Array(repeating: Day.defaultBgColor, count: 7)
    var weekdaysFgColor = Array(repeating: DayColor(), count: 7)
    var weekdaysText = Array(repeating: ModelData.DEFAULT_TEXT, count: 7)
}
