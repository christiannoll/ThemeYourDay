import SwiftUI

class Tools: ObservableObject {
    @Published var fgColorVisible = false
    @Published var bgColorVisible = false
    @Published var fontPickerVisible = false
}


struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.calendar) var calendar
    @State private var themetext = "..."
    @State private var fgColor = Color.white
    @State private var bgColor = Color(red: 153/255, green: 204/255, blue: 1)
    @State private var editMode = false
    @State private var selection: String? = nil
    @State private var fontname = ""
    @StateObject private var tools = Tools()
    
    private var year: DateInterval {
        calendar.dateInterval(of: .year, for: Date())!
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
                    destination: CalendarView(interval: year) { date in
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
                
                VStack {
                    Spacer()
                    Text(getDate())
                        .background(Color.gray)
                        .foregroundColor(.white)
                        
                    TextEditor(text: $themetext)
                        .font(modelData.selectedDay.fontname == "" ? .largeTitle : .custom(modelData.selectedDay.fontname, size: 25))
                        .background(bgColor)
                        .foregroundColor(fgColor)
                        .multilineTextAlignment(.center)
                        .disableAutocorrection(true)
                        .lineSpacing(20)
                        .disabled(!editMode)
                        .onAppear {
                            themetext = modelData.selectedDay.text
                            fgColor = getTextColor()
                            bgColor = getBackgroundColor()
                            fontname = modelData.selectedDay.fontname
                        }
                        .onTapGesture {
                            editMode = true
                        }
                        .onChange(of: themetext, perform: saveText)
                        .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
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
                                themetext = modelData.selectedDay.text
                                fgColor = getTextColor()
                                bgColor = getBackgroundColor()
                            }))
                }
                .background(Color.gray)
                .cornerRadius(25.0)
                .frame(height: 400)
                .padding()
            
                Spacer()
                
                if tools.fgColorVisible {
                    ColorPicker("Select Text Color", selection: $fgColor)
                        .labelsHidden()
                        .onChange(of: fgColor) {newValue in
                            saveFgColor(newValue)
                        }
                        .opacity(tools.fgColorVisible ? 1 : 0)
                        .padding()
                    }
                else if tools.fontPickerVisible {
                    FontPickerView(font: $fontname, isShow: $tools.fontPickerVisible)
                        .onDisappear(){
                            modelData.saveFontname(fontname)
                            modelData.writeJSON()
                        }
                }
                else {
                    ColorPicker("Select Background Color", selection: $bgColor)
                        .labelsHidden()
                        .onChange(of: bgColor) {newValue in
                            saveBgColor(newValue)
                        }
                        .opacity(tools.bgColorVisible ? 1 : 0)
                        .padding()
                    }
                Spacer()
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
    
    private func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateString = formatter.string(from: modelData.selectedDay.id)
        return dateString
    }
    
    private func saveText(_ text: String) {
        modelData.selectedDay.text = text
        modelData.writeJSON()
    }
    
    private func saveFgColor(_ fgColor: Color) {
        let uiColor = UIColor(fgColor)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        modelData.saveFgColor(r: Double(red), g: Double(green), b: Double(blue), a: Double(alpha))
        modelData.writeJSON()
    }
    
    private func saveBgColor(_ bgColor: Color) {
        let uiColor = UIColor(bgColor)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        modelData.saveBgColor(r: Double(red), g: Double(green), b: Double(blue), a: Double(alpha))
        modelData.writeJSON()
    }
    
    private func getTextColor() -> Color {
        return Color(red:modelData.selectedDay.fgColor.r, green:modelData.selectedDay.fgColor.g, blue:modelData.selectedDay.fgColor.b, opacity:modelData.selectedDay.fgColor.a)
    }
    
    private func getBackgroundColor() -> Color {
        return modelData.selectedDay.bgColor.color
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
