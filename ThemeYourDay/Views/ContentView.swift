import SwiftUI

class Tools: ObservableObject {
    @Published var fgColorVisible = false
    @Published var bgColorVisible = false
    @Published var canvasVisible = false
}

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.calendar) var calendar
    @State private var selection: String? = nil
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
                            .overlay(
                                Circle().stroke(.white, lineWidth: modelData.isToday(day: day) ? 1 : 0).padding(3)
                            )                    },
                    tag: "Calendar", selection: $selection) { EmptyView() }
                
                //Spacer()
                
                VStack {
                    if tools.canvasVisible {
                        CanvasView(toolPickerIsActive: $tools.canvasVisible)
                            .padding(.top, 90)
                    }
                    else {
                        CarouselView()
                    }
                }
                .padding(.top, 100)
                .frame(height: 376)
            
                Spacer()
                
                VStack {
                    VStack {
                        if tools.fgColorVisible {
                            FontSizeView()
                                .padding([.leading, .trailing], 20)
                            ColorStripView(dayColor: $modelData.selectedDay.fgColor, colors: modelData.settings.fgColors, saveColorAction: colorStripMV.saveFgColor)
                                .padding()
                        }
                    }
                
                    if tools.bgColorVisible {
                        VStack {
                            Spacer()
                            ColorStripView(dayColor: $modelData.selectedDay.bgColor, colors: modelData.settings.bgColors, saveColorAction: colorStripMV.saveBgColor)
                                .padding()
                        }
                    }
                }
                .offset(y: offset.height)
                .animation(.interactiveSpring(), value: offset)
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.width < 50 {
                                offset = gesture.translation
                            }
                        }
                        .onEnded { _ in
                            if abs(offset.height) > 100 {
                                if tools.bgColorVisible {
                                    tools.bgColorVisible.toggle()
                                }
                                else {
                                    tools.fgColorVisible.toggle()
                                }
                            }
                            offset = .zero
                        }
                )
                //.frame(height:120)
                
                ToolBarView()
                    .ignoresSafeArea()
                    .frame(height: 50)
                    .environmentObject(tools)
                    
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
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

