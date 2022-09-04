import SwiftUI

struct DayTextView: View {
    
    @Binding var dayText: String
    let weekday: String
    
    var body: some View {
        HStack {
            Text(weekday)
            Spacer()
            Spacer()
            TextField("day text", text: $dayText)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct DayTextView_Previews: PreviewProvider {
    static var previews: some View {
        DayTextView(dayText: .constant("New Day"), weekday: "Monday")
    }
}
