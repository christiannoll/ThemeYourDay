import Foundation

struct Settings: Hashable, Codable {
    var fgColors: [DayColor]
    var bgColors: [DayColor]
    var textLineSpacing = 20
}
