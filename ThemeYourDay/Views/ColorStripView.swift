import SwiftUI

struct ColorStripView: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var color: Color
    var colors: [DayColor]
    
    var body: some View {
        HStack {
            ColorPicker("Select Text Color", selection: $color)
                .labelsHidden()
                .padding()
            ForEach(colors, id: \.self) { col in
                RoundedRectangle(cornerRadius: 10)
                    .fill(col.color)
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        color = col.color
                    }
            }
        }
    }
}

struct ColorStripView_Previews: PreviewProvider {
    static var previews: some View {
        ColorStripView(color: .constant(Color.white), colors: [DayColor]())
            .environmentObject(ModelData())
    }
}
