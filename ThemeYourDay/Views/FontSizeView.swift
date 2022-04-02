import SwiftUI

struct FontSizeView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        HStack {
            Label("Size:", systemImage: "textformat.size")
                .labelStyle(.titleOnly)
                .font(.subheadline)
            Picker("Font size", selection: $modelData.selectedDay.textStyle) {
                Text("Large").tag(TextStyle.largeTitle)
                Text("Medium").tag(TextStyle.title)
                Text("Small").tag(TextStyle.title2)
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
