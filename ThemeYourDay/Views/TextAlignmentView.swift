import SwiftUI

struct TextAlignmentView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var alignment: MyTextAlignment = MyTextAlignment.center
    
    var body: some View {
        HStack {
            /*Label("Align:", systemImage: "textformat.alignleft")
                .labelStyle(.titleOnly)
                .font(.subheadline)*/
            Picker("Text alignment", selection: $alignment) {
                Image(systemName: "text.alignleft").tag(MyTextAlignment.leading)
                Image(systemName: "text.aligncenter").tag(MyTextAlignment.center)
                Image(systemName: "text.alignright").tag(MyTextAlignment.trailing)
            }
            .pickerStyle(.segmented)
            .onChange(of: alignment) {
                if let selectedDay = modelData.selectedMyDay {
                    selectedDay.textAlignment = alignment
                }
            }
        }
    }
}

struct TextAlignmentView_Previews: PreviewProvider {
    static var previews: some View {
        TextAlignmentView()
    }
}
