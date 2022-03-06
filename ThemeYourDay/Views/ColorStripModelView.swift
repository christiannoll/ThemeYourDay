import SwiftUI

struct ColorStripModelView {
    
    func saveFgColor(_ fgColor: Color, _ modelData: ModelData) {
        let uiColor = UIColor(fgColor)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        modelData.saveFgColor(r: Double(red), g: Double(green), b: Double(blue), a: Double(alpha))
        modelData.save()
    }
    
    func saveBgColor(_ bgColor: Color, _ modelData: ModelData) {
        let uiColor = UIColor(bgColor)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        modelData.saveBgColor(r: Double(red), g: Double(green), b: Double(blue), a: Double(alpha))
        modelData.save()
    }
}
