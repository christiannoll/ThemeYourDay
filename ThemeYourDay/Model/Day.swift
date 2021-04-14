import Foundation
import SwiftUI

struct Day: Hashable, Codable, Identifiable {
    var id: Date
    var text: String
    var fgColor: DayColor
    var bgColor = DayColor(r:153/255, g:204/255, b:1.0, a:1.0)
}

struct DayColor: Codable, Hashable {
    var r: Double = 1.0
    var g: Double = 1.0
    var b: Double = 1.0
    var a: Double = 1.0
    
    var color: Color {
        Color(red:r, green:g, blue:b, opacity:a)
    }
}

extension DayColor: Equatable {
    static func == (lhs: DayColor, rhs: DayColor) -> Bool {
        return
            lhs.r == rhs.r &&
            lhs.g == rhs.g &&
            lhs.b == rhs.b &&
            lhs.a == rhs.a
    }
}

extension DayColor {
    func invert() -> Color {
        let _red  =  255.0 - (r * 255.0)
        let _green =  255.0 - (g * 255.0)
        let _blue  =  255.0 - (b * 255.0)
        return Color(red: _red / 255.0, green: _green / 255.0, blue: _blue / 255.0, opacity: self.a)
    }
}
