import SwiftUI

struct ColorStripView: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var color: Color
    
    var body: some View {
        ColorPicker("Select Text Color", selection: $color)
            .labelsHidden()
            .padding()
    }
}

struct ColorStripView_Previews: PreviewProvider {
    var _color = Color.white
    static var previews: some View {
        ColorStripView(color: .constant(Color.white))
            .environmentObject(ModelData())
    }
}
