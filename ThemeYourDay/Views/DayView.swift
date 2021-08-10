import SwiftUI

struct DayView: View {
    
    @EnvironmentObject var modelData: ModelData
    @State private var editMode = false
    @Binding var day: Day
    var isSelectedDay: Bool
    
    var body: some View {
        LazyVStack {
            Spacer()
            Text(getDate())
                .background(Color.gray)
                .foregroundColor(.white)
                
            TextEditor(text: $day.text)
                .font(day.fontname == "" ? .largeTitle : .custom(day.fontname, size: 34))
                .background(day.bgColor.color)
                .foregroundColor(day.fgColor.color)
                .frame(height: 300)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .lineSpacing(20)
                .disabled(!editMode)
                .onTapGesture {
                    editMode = !editMode
                }
                .onChange(of: day.text, perform: saveText)
                /*.gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width < 0 {
                            // left
                            modelData.selectNextDay()
                        }

                        if value.translation.width > 0 {
                            // right
                            modelData.selectDayBefore()
                        }
                        modelData.writeJSON()
                        editMode = false
                    }))*/
        }
        .background(Color.gray)
        .cornerRadius(25.0)
        .padding()
    }
    
    private func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateString = formatter.string(from: day.id)
        return dateString
    }
    
    private func saveText(_ text: String) {
        if isSelectedDay {
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
