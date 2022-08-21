import SwiftUI

struct ToolBarView: View {
    @EnvironmentObject var tools: Tools
    
    var body: some View {
        NavigationView {
            Spacer()
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { tools.canvasVisible.toggle()
                        tools.visibleTool = .None
                    }) {
                        Image(systemName: "pencil.tip.crop.circle")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        tools.visibleTool = tools.visibleTool == .Textformat ? .None : .Textformat
                    }) {
                        Image(systemName: "textformat")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        tools.visibleTool = tools.visibleTool == .Foreground ? .None : .Foreground
                    }) {
                        Image(systemName: "note.text")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        tools.visibleTool = tools.visibleTool == .Background ? .None : .Background
                    }) {
                        Image(systemName: "note")
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
                        Button(action: { }) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    } label: { Image(systemName: "ellipsis.circle") }
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
