import SwiftUI

class Tools: ObservableObject {
    
    enum ToolType {
        case None, Foreground, Background, Textformat
    }
    
    @Published var visibleTool = ToolType.None
    @Published var canvasVisible = false
    @Published var settingsVisible = false
    
    var saveThemeAsImage: () -> Void
    var shareThemeAsImage: () -> Void
    
    init(saveTheme: @escaping () -> Void, shareTheme: @escaping () -> Void) {
        saveThemeAsImage = saveTheme
        shareThemeAsImage = shareTheme
    }
    
    static func showShareSheet(fileName: String) {
        let file = FileManager.sharedContainerURL().appendingPathComponent(fileName)
        let url = NSURL.fileURL(withPath: file.path)
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

struct ContentView: View {
    
    private enum Selection {
        case dayList
        case calendar
    }
    
    @EnvironmentObject var modelData: ModelData
    @Environment(\.calendar) var calendar
    @State private var path: [Selection] = []
    @StateObject private var tools = Tools(saveTheme: {}, shareTheme: {})
    private var colorStripMV =  ColorStripModelView()
    @State private var offset: CGSize = .zero
    @State private var stickerViewShown = false
    @State private var snippetViewShown = false
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
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
                
                Spacer()
                
                VStack {
                    if tools.canvasVisible {
                        CanvasView(toolPickerIsActive: $tools.canvasVisible)
                    }
                    else {
                        CarouselView()
                    }
                }
                .frame(maxHeight: getHeight())
            
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
                .frame(maxHeight: 80)
                
                ToolBarView()
                    .ignoresSafeArea()
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
                ToolbarItemGroup(placement: .keyboard) {
                    Button(action: { stickerViewShown = true }) {
                        Image(systemName: "eyes")
                    }
                    Button(action: { snippetViewShown = true }) {
                        Image(systemName: "text.quote")
                    }
                    Spacer()
                }
            }
        }
        .environmentObject(modelData)
        .onAppear {
            tools.saveThemeAsImage = saveThemeInAlbum
            tools.shareThemeAsImage = shareTheme
        }
        .sheet(isPresented: $stickerViewShown) {
            StickerView()
                .presentationDetents([.fraction(0.3), .medium])
        }
        .sheet(isPresented: $snippetViewShown) {
            SnippetView()
                .presentationDetents([.fraction(0.3), .medium])
//                .safeAreaInset(edge: .bottom, alignment: .center, spacing: 0) {
//                    Color.clear
//                        .frame(height: 10)
//                        .background(.background)
//                }
        }
    }
    
    func saveThemeInAlbum() {
        saveThemeAsImage(inAlbum: true)
    }
    
    func shareTheme() {
        saveThemeAsImage(inAlbum: false)
        Tools.showShareSheet(fileName: modelData.getSharedThemeFileName())
    }
    
    static func getHeight(_ horizontalSizeClass: UserInterfaceSizeClass?,
                          _ verticalSizeClass: UserInterfaceSizeClass?) -> CGFloat {
        if verticalSizeClass == .regular && horizontalSizeClass == .regular {
            return 500
        }
        return 300
    }
    
    private func getHeight() -> CGFloat {
        ContentView.getHeight(horizontalSizeClass, verticalSizeClass) + 76
    }
    
    private func saveThemeAsImage(inAlbum: Bool) {
        let dayView = DayView(day: $modelData.selectedDay, isSelectedDay: true, readOnly: true)
            .environmentObject(modelData)
        let renderer = ImageRenderer(content: dayView)
        renderer.scale = 3
         
        if let image = renderer.uiImage {
            if inAlbum {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            else {
                if let data = image.pngData() {
                    let filename = FileManager.sharedContainerURL().appendingPathComponent(modelData.getSharedThemeFileName())
                    try? data.write(to: filename)
                }
            }
        }
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

