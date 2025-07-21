import SwiftUI
import SwiftData

struct ColorStripView: View {
    @Environment(ModelData.self) var modelData
    @Environment(\.modelContext) private var context
    @State var dayColor = DayColor()
    let isBackground: Bool
    var colors: [DayColor]
    var saveColorAction: (Color, ModelData, Settings?) -> Void
    
    @Query() var settings: [Settings]
    
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
                        if let day = modelData.selectedDay {
                            if isBackground {
                                day.bgColor = col
                            } else {
                                day.fgColor = col
                            }
                            modelData.save(context)
                        }
                    }
            }
        }
        .onChange(of: dayColor) {
            saveColorAction(dayColor.color, modelData, settings.first)
            modelData.save(context)
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
        ColorStripView(isBackground: true, colors: [DayColor](), saveColorAction:saveColor(_:_:_:))
            .environment(ModelData())
    }
    
    static func saveColor(_ color: Color, _ modelData: ModelData, _ settings: Settings?) {
    }
}
