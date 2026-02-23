import SwiftUI
import SwiftData

struct ContentView: View {
    
    private enum Selection {
        case dayList
        case calendar
    }
    
    @Environment(ModelData.self) var modelData
    @Environment(\.calendar) var calendar
    @Environment(\.modelContext) private var context
    @State private var path: [Selection] = []
    @State private var tools = Tools(saveTheme: {}, shareTheme: {})
    private var colorStripMV =  ColorStripModelView()
    @State private var offset: CGSize = .zero
    @State private var stickerViewShown = false
    @State private var snippetViewShown = false
    @State private var monthOffset: Int = 0
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @State private var preferredColumn = NavigationSplitViewColumn.detail
    
    @Query(sort: [SortDescriptor(\Day.id)]) private var days: [Day]
    @Query() var settings: [Settings]
    
    private var monthly: DateInterval {
        let endDate = Date().getNextMonth(offset: monthOffset)
        let startDate = Date().getPreviousMonth(offset: monthOffset)
        return DateInterval(start: startDate!, end: endDate!)
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
                .padding(.horizontal, 5)

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
                            if let mySettings = settings.first {
                                ColorStripView(isBackground: false, colors: mySettings.fgColors, saveColorAction: colorStripMV.saveFgColor)
                                    .padding()
                            }
                        }
                    }

                    if tools.visibleTool == .Background {
                        VStack {
                            Spacer()
                            if let mySettings = settings.first {
                                ColorStripView(isBackground: true, colors: mySettings.bgColors, saveColorAction: colorStripMV.saveBgColor)
                                    .padding()
                            }
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
                    .environment(tools)

            }
            .onChange(of: modelData.selectedIndex) {
                preferredColumn =
                NavigationSplitViewColumn.detail
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationDestination(for: Selection.self) { selection in
                switch selection {
                case .dayList:
                    DayList()
                case .calendar:
                    CalendarView(interval: monthly, nextMonth: incrementMonthOffset, previousMoth: decrementMonthOffset) { date in
                        let day = findDay(date)
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
                                Circle().stroke(getCalendarBackgroundColor(day), lineWidth: modelData.isToday(day: day) ? 1 : 0).padding(-4)
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
                    HStack(spacing: 20) {
                        Button { stickerViewShown = true
                        } label: {
                            VStack {
                                Image(systemName: "eyes")
                                Text("Stickers")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Button { snippetViewShown = true
                        } label : {
                            VStack {
                                Image(systemName: "text.quote")
                                Text("Snippets")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    Spacer()
                }
            }
        }
        .environment(modelData)
        .onAppear {
            tools.saveThemeAsImage = saveThemeInAlbum
            tools.shareThemeAsImage = shareTheme

            for (index, day) in days.enumerated() {
                ModelData.indexCache[day.id.noon] = index
            }
        }
        .sheet(isPresented: $stickerViewShown) {
            StickerView()
                .presentationDetents([.fraction(0.3), .medium])
        }
        .sheet(isPresented: $snippetViewShown) {
            SnippetsOverview()
                .presentationDetents([.fraction(0.3), .medium])
        }
    }
    
    func incrementMonthOffset() {
        monthOffset += 1
        if let mySettings = settings.first {
            modelData.insertNewDays(context: context, days: days, settings: mySettings, monthOffset: monthOffset)
        }
    }
    
    func decrementMonthOffset() {
        monthOffset -= 1
    }
    
    @MainActor func saveThemeInAlbum() {
        saveThemeAsImage(inAlbum: true)
    }
    
    @MainActor func shareTheme() {
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
    
    private func findDay(_ date: Date) -> Day? {
        if let index = ModelData.indexCache[date.noon] {
            if days.count > index {
                return days[index]
            }
        }
        return nil
    }
    
    @MainActor private func saveThemeAsImage(inAlbum: Bool) {
        let dayView = DayView(day: days[modelData.selectedIndex], readOnly: true)
            .environment(modelData)
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
        day?.bgColor.color ?? Color.blue
    }
    
    private func getCalendarForegroundColor(_ day: Day?) -> Color {
        day?.fgColor.color ?? Color.white
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}

