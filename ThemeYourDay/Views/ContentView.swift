import SwiftUI

class Tools: ObservableObject {
    
    enum ToolType {
        case None, Foreground, Background, Textformat
    }
    
    @Published var visibleTool = ToolType.None
    @Published var canvasVisible = false
    @Published var settingsVisible = false
}

struct ContentView: View {
    
    private enum Selection {
        case dayList
        case calendar
    }
    
    @EnvironmentObject var modelData: ModelData
    @Environment(\.calendar) var calendar
    @State private var path: [Selection] = []
    @StateObject private var tools = Tools()
    private var colorStripMV =  ColorStripModelView()
    @State private var offset: CGSize = .zero
    
    private var monthly: DateInterval {
        let endDate = Date().getNextMonth()
        let startDate = Date().getPreviousMonth()
        return DateInterval(start: startDate!, end: endDate!)
    }
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        let dragGesture = DragGesture()
            .onChanged { gesture in
                if gesture.translation.width < 50 {
                    offset = gesture.translation
                }
            }
            .onEnded { _ in
                if abs(offset.height) > 100 {
                    tools.visibleTool = .None
                }
                offset = .zero
            }
        
        NavigationStack(path: $path) {
            VStack {
                NavigationLink("", value: Selection.dayList)
                NavigationLink("", value: Selection.calendar)
                
                //Spacer()
                
                VStack {
                    if tools.canvasVisible {
                        CanvasView(toolPickerIsActive: $tools.canvasVisible)
                            .padding(.top, 130)
                    }
                    else {
                        CarouselView()
                    }
                }
                .padding(.top, 140)
                .frame(height: 376)
            
                Spacer()
                
                VStack {
                    if tools.visibleTool == .Textformat {
                        VStack {
                            Spacer()
                            TextAlignmentView()
                                .padding([.leading, .trailing], 30)
                                .padding(.bottom, 15)
                            FontSizeView()
                                .padding([.leading, .trailing], 30)
                                .padding(.bottom, 15)
                        }
                    }
                    
                    if tools.visibleTool == .Foreground {
                        VStack {
                            Spacer()
                            ColorStripView(dayColor: $modelData.selectedDay.fgColor, colors: modelData.settings.fgColors, saveColorAction: colorStripMV.saveFgColor)
                                .padding()
                        }
                    }
                
                    if tools.visibleTool == .Background {
                        VStack {
                            Spacer()
                            ColorStripView(dayColor: $modelData.selectedDay.bgColor, colors: modelData.settings.bgColors, saveColorAction: colorStripMV.saveBgColor)
                                .padding()
                        }
                    }
                }
                .offset(y: offset.height)
                .animation(.interactiveSpring(), value: offset)
                .simultaneousGesture(dragGesture)
                .sheet(isPresented: $tools.settingsVisible,
                               onDismiss: {  },
                               content: { SettingsView() })
                //.frame(height:120)
                
                ToolBarView()
                    .ignoresSafeArea()
                    .frame(height: 50)
                    .environmentObject(tools)
                    
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationDestination(for: Selection.self) { selection in
                switch selection {
                case .dayList:
                    DayList()
                case .calendar:
                    CalendarView(interval: monthly) { date in
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
                            .overlay(
                                Circle().stroke(.white, lineWidth: modelData.isToday(day: day) ? 1 : 0).padding(4)
                            )
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { path.append(.dayList) }) {
                        Image(systemName: "list.bullet")
                    }.padding()
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { path.append(.calendar) }) {
                        Image(systemName: "calendar")
                    }.padding()
                    
                }
            }
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

