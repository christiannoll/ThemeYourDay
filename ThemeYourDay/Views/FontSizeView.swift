import SwiftUI

struct FontSizeView: View {
    @EnvironmentObject var modelData: ModelData
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
                style = modelData.selectedMyDay?.textStyle ?? TextStyle.largeTitle
            }
            .onChange(of: style) {
                if let selectedDay = modelData.selectedMyDay {
                    selectedDay.textStyle = style
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
