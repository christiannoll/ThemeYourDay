import SwiftUI

struct DayColorView: View {
    
    @Binding var dayColor: DayColor
    let weekday: String
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(dayColor.color)
                .frame(width: 46, height: 46)
                .padding(3)
            Text(weekday)
            Spacer()
            ColorPicker("Select Text Color", selection: $dayColor.color)
                .labelsHidden()
                .padding()
        }
    }
}

struct DayColorView_Previews: PreviewProvider {
    static var previews: some View {
        DayColorView(dayColor: .constant(Day.defaultBgColor), weekday: "Monday")
    }
}
