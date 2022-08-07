import Foundation
import SwiftUI

struct Day: Hashable, Codable, Identifiable {
    var id: Date
    var text: String
    var fgColor: DayColor
    var bgColor = defaultBgColor
    var fontname = ""
    var starred = false
    var textStyle = TextStyle.largeTitle
    var textAlignment = MyTextAlignment.center
    var hasImage = false
    
    static let defaultBgColor = DayColor(r:153/255, g:204/255, b:1.0, a:1.0)
}

extension Day {
    func font() -> Font {
        switch textStyle {
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title
        case .title2:
            return .title2
        case .title3:
            return .title3
        }
    }
}

extension Day {
    func getTextAlignment() -> TextAlignment {
        switch textAlignment {
        case .center:
            return .center
        case .leading:
            return .leading
        case .trailing:
            return.trailing
        }
    }
}

extension Day {
    func getAlignment() -> Alignment {
        switch textAlignment {
        case .center:
            return .top
        case .leading:
            return .topLeading
        case .trailing:
            return .topTrailing
        }
    }
}

struct DayColor: Codable, Hashable {
    var r: Double = 1.0
    var g: Double = 1.0
    var b: Double = 1.0
    var a: Double = 1.0
    
    var color: Color {
        get {
            Color(red:r, green:g, blue:b, opacity:a)
        }
        set (newColor) {
            r = Double(newColor.components.red)
            g = Double(newColor.components.green)
            b = Double(newColor.components.blue)
            a = Double(newColor.components.opacity)
        }
    }
}

enum TextStyle : Int, Codable, CodingKey {
    case largeTitle
    case title
    case title2
    case title3
}

enum MyTextAlignment : Int, Codable, CodingKey {
    case center
    case leading
    case trailing
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

extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {

        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            // You can handle the failure here as you want
            return (0, 0, 0, 0)
        }

        return (r, g, b, o)
    }
}
