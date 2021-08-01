import SwiftUI

class Tools: ObservableObject {
    @Published var fgColorVisible = false
    @Published var bgColorVisible = false
    @Published var fontPickerVisible = false
}

extension Date {
    func getNextMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)
    }

    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
}


struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.calendar) var calendar
    @State private var themetext = "..."
    @State private var fgColor = Color.white
    @State private var bgColor = Color(red: 153/255, green: 204/255, blue: 1)
    @State private var fontname = ""
    @State private var selection: String? = nil
    @StateObject private var tools = Tools()
    private var colorStripMV =  ColorStripModelView()
    
    
    private var monthly: DateInterval {
        let endDate = Date().getNextMonth()
        let startDate = Date().getPreviousMonth()
        return DateInterval(start: startDate!, end: endDate!)
    }
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: DayList(),
                    tag: "DayList", selection: $selection) { EmptyView() }
                NavigationLink(
                    destination: CalendarView(interval: monthly) { date in
                        Text("30")
                            .hidden()
                            .padding(8)
                            .background(getCalendarBackgroundColor(date))
                            .clipShape(Circle())
                            .padding(.vertical, 4)
                            .overlay(
                                Text(String(self.calendar.component(.day, from: date)))
                                    .foregroundColor(getCalendarForegroundColor(date))
                            )
                    },
                    tag: "Calendar", selection: $selection) { EmptyView() }
                Spacer()
                
                DayView(themetext: $themetext, fgColor: $fgColor, bgColor: $bgColor, fontname: $fontname)
            
                Spacer()
                
                FontPickerView(font: $fontname, isShow: $tools.fontPickerVisible)
                    .onChange(of: tools.fontPickerVisible) { newValue in
                        if !newValue {
                            modelData.saveFontname(fontname)
                            modelData.writeJSON()
                        }
                    }
                    .frame(width: 0, height: 0)
                
                Spacer()
                
                ZStack {
                    ColorStripView(color: $fgColor, colors: modelData.settings.fgColors)
                        .opacity(tools.fgColorVisible ? 1 : 0)
                        .padding()
                        .onChange(of: fgColor) {newValue in
                            colorStripMV.saveFgColor(newValue, modelData)
                        }
                
                    ColorStripView(color: $bgColor, colors: modelData.settings.bgColors)
                        .opacity(tools.bgColorVisible ? 1 : 0)
                        .padding()
                        .onChange(of: bgColor) {newValue in
                            colorStripMV.saveBgColor(newValue, modelData)
                        }
                }
                
                ToolBarView()//.border(Color.green)
                    .ignoresSafeArea()
                    .frame(height: 50)
                    .environmentObject(tools)
                    
            }
            /*.contentShape(Rectangle())
            .onTapGesture {
                editMode = false
            }*/
            
            .navigationBarItems(
                leading:
                    Button(action: { selection = "DayList" }) {
                        Image(systemName: "list.bullet")
                    }.padding(),
                
                trailing:
                    Button(action: { selection = "Calendar" }) {
                        Image(systemName: "calendar")
                    }.padding()
            )
        }
        .environmentObject(modelData)
        
    }
    
    private func getCalendarBackgroundColor(_ date: Date) -> Color {
        guard let day = modelData.findDay(date) else {
            return Color.blue
        }
        return day.bgColor.color
    }
    
    private func getCalendarForegroundColor(_ date: Date) -> Color {
        guard let day = modelData.findDay(date) else {
            return Color.black
        }
        return day.fgColor.color
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
