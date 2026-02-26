import SwiftUI

struct DayTextView: View {
    
    @State var dayText: String
    let weekday: String
    let index: Int
    let save: (String, Int) -> Void
    
    init(dayText: String, weekday: String, index: Int, save: @escaping (_ dayText: String, _ index: Int) -> Void) {
        self._dayText = State(initialValue: dayText)
        self.weekday = weekday
        self.index = index
        self.save = save
    }
    
    var body: some View {
        HStack {
            Text(weekday)
            Spacer()
            Spacer()
            TextField("day text", text: $dayText)
                .multilineTextAlignment(.trailing)
                .onChange(of: dayText) {
                    save(dayText, index)
                }
        }
    }
}

#Preview {
    DayTextView(dayText: "New Day", weekday: "Monday", index: 0, save: {_,_ in })
}
