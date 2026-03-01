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
        HStack(spacing: 20) {
            Button { tools.canvasVisible.toggle()
                tools.visibleTool = .None
            } label: {
                Image(systemName: "pencil.tip.crop.circle")
                    .foregroundColor(.secondary)
                    .imageScale(.large)
            }
            Button {
                withAnimation {
                    tools.visibleTool = textToolVisible ? .None : .Textformat
                }
            } label: {
                Image(systemName: "textformat")
                    .foregroundColor(textToolVisible ? .accentColor : .secondary)
                    .imageScale(.large)
            }
            Button {
                withAnimation {
                    tools.visibleTool = foregroundToolVisible ? .None : .Foreground
                }
            } label: {
                Image(systemName: "note.text")
                    .foregroundColor(foregroundToolVisible ? .accentColor : .secondary)
                    .imageScale(.large)
            }
            Button {
                withAnimation {
                    tools.visibleTool = backgroundToolVisible ? .None : .Background
                }
            } label: {
                Image(systemName: "note")
                    .foregroundColor(backgroundToolVisible ? .accentColor : .secondary)
                    .imageScale(.large)
            }
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
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundColor(.secondary)
                    .imageScale(.large)
            }
        }
    }
}

#Preview {
    ToolBarView()
}
