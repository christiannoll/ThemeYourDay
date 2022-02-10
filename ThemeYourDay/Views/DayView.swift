import SwiftUI

struct DayView: View {
    
    @EnvironmentObject var modelData: ModelData
    @FocusState private var focusMode: Bool
    @Binding var day: Day
    var isSelectedDay: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text(getDate())
                .background(Color.gray)
                .foregroundColor(.white)
            Spacer()
                
            TextEditor(text: $day.text)
                .font(day.fontname == "" ? .largeTitle : .custom(day.fontname, size: 34))
                .background(day.bgColor.color)
                .foregroundColor(day.fgColor.color)
                .frame(height: 300)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .lineSpacing(20)
                .onTapGesture {
                    focusMode = !focusMode
                }
                .focused($focusMode)
                .onChange(of: day.text, perform: saveText)
        }
        .background(.gray)
        .cornerRadius(25.0)
        .padding()
    }
    
    private func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateString = formatter.string(from: day.id)
        let weekday = formatter.weekdaySymbols[Calendar.current.component(.weekday, from: day.id) - 1]

        return weekday + " " + dateString
    }
    
    private func saveText(_ text: String) {
        if modelData.days[modelData.selectedIndex] == day {
            modelData.selectedDay.text = text
            //print(text)
            modelData.writeJSON()
        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(day:.constant(Day(id: Date().noon, text: "Today", fgColor: DayColor())), isSelectedDay: false)
            .environmentObject(ModelData())
    }
}
