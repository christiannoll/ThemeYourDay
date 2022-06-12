import SwiftUI

struct TextAlignmentView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        HStack {
            /*Label("Align:", systemImage: "textformat.alignleft")
                .labelStyle(.titleOnly)
                .font(.subheadline)*/
            Picker("Text alignment", selection: $modelData.selectedDay.textAlignment) {
                Image(systemName: "text.alignleft").tag(MyTextAlignment.leading)
                Image(systemName: "text.aligncenter").tag(MyTextAlignment.center)
                Image(systemName: "text.alignright").tag(MyTextAlignment.trailing)
            }
            .pickerStyle(.segmented)
            .onChange(of: modelData.selectedDay.textAlignment) {_ in
                modelData.save()
            }
        }
    }
}

struct TextAlignmentView_Previews: PreviewProvider {
    static var previews: some View {
        TextAlignmentView()
    }
}
