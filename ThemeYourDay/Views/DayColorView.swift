import SwiftUI

struct DayColorView: View {
    
    @State var dayColor: DayColor
    let weekday: String
    let index: Int
    let save: (DayColor, Int) -> Void
    
    init(dayColor: DayColor, weekday: String, index: Int, save: @escaping (_ dayColor: DayColor, _ index: Int) -> Void) {
        self._dayColor = State(initialValue: dayColor)
        self.weekday = weekday
        self.index = index
        self.save = save
    }
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(dayColor.color)
                .frame(width: 46, height: 46)
                .padding(3)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(strokeColor, lineWidth: 2)
                )
            Text(weekday)
            Spacer()
            ColorPicker("Select Text Color", selection: $dayColor.color)
                .labelsHidden()
                .padding()
                .onChange(of: dayColor) {
                    save(dayColor, index)
                }
        }
    }
    
    private var strokeColor: Color {
        if dayColor.color == .white {
            return .gray
        }
        return dayColor.color
    }
}

#Preview {
    DayColorView(dayColor: Day.defaultBgColor, weekday: "Monday", index: 0, save: {_,_ in })
}
