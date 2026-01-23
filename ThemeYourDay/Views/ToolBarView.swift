import SwiftUI
import SwiftData

struct ToolBarView: View {
    
    @Environment(Tools.self) var tools
    @Environment(ModelData.self) var modelData
    
    @Query(sort: [SortDescriptor(\Day.id)]) private var days: [Day]
    
    private var textToolVisible: Bool {
        tools.visibleTool == .Textformat
    }
    
    private var foregroundToolVisible: Bool {
        tools.visibleTool == .Foreground
    }
    
    private var backgroundToolVisible: Bool {
        tools.visibleTool == .Background
    }
    
    var body: some View {
        HStack {
            Spacer()
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button { tools.canvasVisible.toggle()
                        tools.visibleTool = .None
                    } label: {
                        Image(systemName: "pencil.tip.crop.circle")
                            .foregroundColor(.secondary)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        withAnimation {
                            tools.visibleTool = textToolVisible ? .None : .Textformat
                        }
                    } label: {
                        Image(systemName: "textformat")
                            .foregroundColor(textToolVisible ? .accentColor : .secondary)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        withAnimation {
                            tools.visibleTool = foregroundToolVisible ? .None : .Foreground
                        }
                    } label: {
                        Image(systemName: "note.text")
                            .foregroundColor(foregroundToolVisible ? .accentColor : .secondary)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        withAnimation {
                            tools.visibleTool = backgroundToolVisible ? .None : .Background
                        }
                    } label: {
                        Image(systemName: "note")
                            .foregroundColor(backgroundToolVisible ? .accentColor : .secondary)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Menu {
                        Button { tools.settingsVisible.toggle() } label: {
                            Label("Settings", systemImage: "gearshape")
                        }
                        Button { tools.shareThemeAsImage() } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        Button { modelData.applyToToday(days) } label: {
                            Label("ApplyToToday", systemImage: "square.and.arrow.up.on.square")
                        }
                        Button { tools.saveThemeAsImage() } label: {
                            Label("SaveTheme", systemImage: "square.and.arrow.down")
                        }
                    } label: { Image(systemName: "ellipsis.circle").foregroundColor(.secondary) }
                }
            }
        }
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView()
    }
}
