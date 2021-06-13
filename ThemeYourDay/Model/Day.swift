import Foundation
import SwiftUI

struct Day: Hashable, Codable, Identifiable {
    var id: Date
    var text: String
    var fgColor: DayColor
    var bgColor = DayColor(r:153/255, g:204/255, b:1.0, a:1.0)
    var fontname = ""
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

extension Double {
    func precised(_ value: Int = 1) -> Double {
        let offset = pow(10, Double(value))
        return (self * offset).rounded() / offset
    }
}

extension DayColor: Equatable {
    static func == (lhs: DayColor, rhs: DayColor) -> Bool {
        return
            lhs.r.precised(5) == rhs.r.precised(5) &&
            lhs.g.precised(5) == rhs.g.precised(5) &&
            lhs.b.precised(5) == rhs.b.precised(5) &&
            lhs.a.precised(5) == rhs.a.precised(5)
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
