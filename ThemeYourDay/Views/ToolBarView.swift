import SwiftUI

struct ToolBarView: View {
    @EnvironmentObject var tools: Tools
    
    var body: some View {
        NavigationView {
            Spacer()
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { tools.fgColorVisible.toggle()
                        tools.bgColorVisible = false
                    }) {
                        Image(systemName: "textformat")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { tools.bgColorVisible.toggle()
                        tools.fgColorVisible = false
                    }) {
                        Image(systemName: "note")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { tools.canvasVisible.toggle()
                        tools.fgColorVisible = false
                    }) {
                        Image(systemName: "pencil.tip.crop.circle")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
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
