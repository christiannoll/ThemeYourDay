import SwiftUI

struct ToolBarView: View {
    
    @EnvironmentObject var tools: Tools
    @EnvironmentObject var modelData: ModelData
    
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
                    Button(action: { tools.canvasVisible.toggle()
                        tools.visibleTool = .None
                    }) {
                        Image(systemName: "pencil.tip.crop.circle")
                            .foregroundColor(.secondary)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        withAnimation {
                            tools.visibleTool = textToolVisible ? .None : .Textformat
                        }
                    }) {
                        Image(systemName: "textformat")
                            .foregroundColor(textToolVisible ? .accentColor : .secondary)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        withAnimation {
                            tools.visibleTool = foregroundToolVisible ? .None : .Foreground
                        }
                    }) {
                        Image(systemName: "note.text")
                            .foregroundColor(foregroundToolVisible ? .accentColor : .secondary)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        withAnimation {
                            tools.visibleTool = backgroundToolVisible ? .None : .Background
                        }
                    }) {
                        Image(systemName: "note")
                            .foregroundColor(backgroundToolVisible ? .accentColor : .secondary)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Menu {
                        Button(action: { tools.settingsVisible.toggle() }) {
                            Label("Settings", systemImage: "gearshape")
                        }
                        Button(action: { tools.shareThemeAsImage() }) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        Button(action: { modelData.applyToToday(modelData.selectedDay) }) {
                            Label("Apply to today", systemImage: "square.and.arrow.up.on.square")
                        }
                        Button(action: { tools.saveThemeAsImage() }) {
                            Label("Save theme", systemImage: "square.and.arrow.down")
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
