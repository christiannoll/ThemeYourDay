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
                .if (day.hasImage) { view in
                    view.background(day.hasImage ? Image(uiImage: loadPngImage()!) : Image(uiImage: UIImage()))
                }
                .background(day.hasImage ? .white : day.bgColor.color)
                .foregroundColor(foregroundColor)
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
        .if (day.hasImage) { view in
            view .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(.gray, lineWidth: 1)
            )
        }
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
    
    private var foregroundColor: Color {
        get {
            return (day.hasImage && day.fgColor.color == .white) ? .accentColor : day.fgColor.color
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
    
    private func loadPngImage() -> UIImage? {
        do {
            let data = try Data(contentsOf: modelData.getPngImageFilename(date: day.id), options: [.mappedIfSafe, .uncached])
            let drawing = UIImage(data: data)
            return drawing
        } catch {
            return nil
        }
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(day:.constant(Day(id: Date().noon, text: "Today", fgColor: DayColor())), isSelectedDay: false)
            .environmentObject(ModelData())
    }
}
