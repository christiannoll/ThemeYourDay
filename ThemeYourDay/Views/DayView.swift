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
                .background(.gray)
                .foregroundColor(.white)
            Spacer()
                
            TextEditor(text: $day.text)
                .font(day.fontname == "" ? day.font() : .custom(day.fontname, size: 34))
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
        .overlay(starOverlay, alignment: .topTrailing)
        
    }
    
    private var starOverlay: some View {
        Image(systemName: day.starred ? "star.fill" : "star")
            .foregroundColor(.white)
            .padding([.top, .trailing], 28)
            .onTapGesture {
                modelData.selectedDay.starred = !day.starred
                modelData.save()
            }
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
            modelData.save()
        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(day:.constant(Day(id: Date().noon, text: "Today", fgColor: DayColor())), isSelectedDay: false)
            .environmentObject(ModelData())
    }
}
