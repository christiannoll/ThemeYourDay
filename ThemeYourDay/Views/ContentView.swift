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
    //@State private var fontname = ""
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
                        let day = modelData.findDay(date)
                        Text("30")
                            .hidden()
                            .padding(8)
                            .background(getCalendarBackgroundColor(day))
                            .clipShape(Circle())
                            .padding(.vertical, 4)
                            .overlay(
                                Text(String(self.calendar.component(.day, from: date)))
                                    .foregroundColor(getCalendarForegroundColor(day))
                            )
                    },
                    tag: "Calendar", selection: $selection) { EmptyView() }
                
                Spacer()
                
                CarouselView()
                    .frame(height: 376)
            
                Spacer()
                
                ZStack {
                    ColorStripView(dayColor: $modelData.selectedDay.fgColor, colors: modelData.settings.fgColors, saveColorAction: colorStripMV.saveFgColor)
                        .opacity(tools.fgColorVisible ? 1 : 0)
                        .padding()
                
                    ColorStripView(dayColor: $modelData.selectedDay.bgColor, colors: modelData.settings.bgColors, saveColorAction: colorStripMV.saveBgColor)
                        .opacity(tools.bgColorVisible ? 1 : 0)
                        .padding()
                }
                
                ToolBarView()//.border(Color.green)
                    .ignoresSafeArea()
                    .frame(height: 50)
                    .environmentObject(tools)
                    
            }
            .sheet(isPresented: $tools.fontPickerVisible) {
                VStack {
                    Button(action: { tools.fontPickerVisible.toggle() }) {
                        Image(systemName: "chevron.down")
                    }.padding()
                    FontPickerView { fontDescriptor in
                        let customFont = UIFont(descriptor: fontDescriptor, size: 18.0)
                        modelData.saveFontname(customFont.fontName)
                        modelData.writeJSON()
                    }
                }
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
    
    private func getCalendarBackgroundColor(_ day: Day?) -> Color {
        day != nil ? day!.bgColor.color : Color.blue
    }
    
    private func getCalendarForegroundColor(_ day: Day?) -> Color {
        day != nil ? day!.fgColor.color : Color.white
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}

