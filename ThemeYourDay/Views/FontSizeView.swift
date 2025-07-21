import SwiftUI

struct FontSizeView: View {
    @Environment(ModelData.self) var modelData
    @Environment(\.modelContext) private var context
    @State private var style: TextStyle = TextStyle.largeTitle
    
    var body: some View {
        HStack {
            Picker("Font size", selection: $style) {
                Text(.large).tag(TextStyle.largeTitle)
                Text(.medium).tag(TextStyle.title)
                Text(.small).tag(TextStyle.title2)
            }
            .pickerStyle(.segmented)
            .onAppear {
                style = modelData.selectedDay?.textStyle ?? TextStyle.largeTitle
            }
            .onChange(of: style) {
                if let selectedDay = modelData.selectedDay {
                    selectedDay.textStyle = style
                    modelData.save(context)
                }
            }
        }
    }
}

struct FontSizeView_Previews: PreviewProvider {
    static var previews: some View {
        FontSizeView()
    }
}
