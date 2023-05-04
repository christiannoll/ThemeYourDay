import SwiftUI

struct FontSizeView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        HStack {
            Picker("Font size", selection: $modelData.selectedDay.textStyle) {
                Text(.large).tag(TextStyle.largeTitle)
                Text(.medium).tag(TextStyle.title)
                Text(.small).tag(TextStyle.title2)
            }
            .pickerStyle(.segmented)
            .onChange(of: modelData.selectedDay.textStyle) {_ in
                modelData.save()
            }
        }
    }
}

struct FontSizeView_Previews: PreviewProvider {
    static var previews: some View {
        FontSizeView()
    }
}
