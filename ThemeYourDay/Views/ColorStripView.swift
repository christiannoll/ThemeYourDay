import SwiftUI

struct ColorStripView: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var dayColor: DayColor
    var colors: [DayColor]
    var saveColorAction: (Color, ModelData) -> Void
    
    var body: some View {
        HStack {
            ColorPicker("Select Text Color", selection: $dayColor.color)
                .labelsHidden()
                .padding()
            ForEach(colors, id: \.self) { col in
                RoundedRectangle(cornerRadius: 10)
                    .fill(col.color)
                    .frame(width: 46, height: 46)
                    .padding(3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(getColor(col), lineWidth: 2)
                    )
                    .onTapGesture {
                        dayColor = col
                    }
            }
        }
        .onChange(of: dayColor) {
            saveColorAction(dayColor.color, modelData)
        }
    }
    
    private func getColor( _ color: DayColor) -> Color {
        if color.color == .white {
            return .gray
        }
        return color.color
    }
}

struct ColorStripView_Previews: PreviewProvider {
    static var previews: some View {
        ColorStripView(dayColor: .constant(DayColor()), colors: [DayColor](), saveColorAction:saveColor(_:_:))
            .environmentObject(ModelData())
    }
    
    static func saveColor(_ color: Color, _ modelData: ModelData) {
    }
}
