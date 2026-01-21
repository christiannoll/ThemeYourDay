import SwiftUI

struct FontSizeView: View {
    @Environment(ModelData.self) var modelData
    @Environment(\.modelContext) private var context
    @State private var style: TextStyle = TextStyle.largeTitle
    
    var body: some View {
        HStack {
            Picker("Font size", selection: $style) {
                Text("Large").tag(TextStyle.largeTitle)
                Text("Medium").tag(TextStyle.title)
                Text("Small").tag(TextStyle.title2)
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
