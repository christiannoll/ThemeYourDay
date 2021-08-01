import SwiftUI

struct DayView: View {
    
    @EnvironmentObject var modelData: ModelData
    @Binding var themetext: String
    @State private var editMode = false
    
    @Binding var fgColor: Color
    @Binding var bgColor: Color
    @Binding var fontname: String
    
    var body: some View {
        LazyVStack {
            Spacer()
            Text(getDate())
                .background(Color.gray)
                .foregroundColor(.white)
                
            TextEditor(text: $themetext)
                .font(modelData.selectedDay.fontname == "" ? .largeTitle : .custom(modelData.selectedDay.fontname, size: 34))
                .background(bgColor)
                .foregroundColor(fgColor)
                .frame(height: 300)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .lineSpacing(20)
                .disabled(!editMode)
                .onAppear {
                    themetext = modelData.selectedDay.text
                    fgColor = getTextColor()
                    bgColor = getBackgroundColor()
                    fontname = modelData.selectedDay.fontname
                    //modelData.printJson()
                }
                .onTapGesture {
                    editMode = !editMode
                }
                .onChange(of: themetext, perform: saveText)
                .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width < 0 {
                            // left
                            modelData.selectNextDay()
                        }

                        if value.translation.width > 0 {
                            // right
                            modelData.selectDayBefore()
                        }
                        modelData.writeJSON()
                        themetext = modelData.selectedDay.text
                        fgColor = getTextColor()
                        bgColor = getBackgroundColor()
                        editMode = false
                    }))
        }
        .background(Color.gray)
        .cornerRadius(25.0)
        .padding()
    }
    
    private func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateString = formatter.string(from: modelData.selectedDay.id)
        return dateString
    }
    
    private func saveText(_ text: String) {
        modelData.selectedDay.text = text
        modelData.writeJSON()
    }
    
    private func getTextColor() -> Color {
        return Color(red:modelData.selectedDay.fgColor.r, green:modelData.selectedDay.fgColor.g, blue:modelData.selectedDay.fgColor.b, opacity:modelData.selectedDay.fgColor.a)
    }
    
    private func getBackgroundColor() -> Color {
        return modelData.selectedDay.bgColor.color
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(themetext: .constant("..."), fgColor: .constant(Color.white), bgColor: .constant(Color.blue), fontname: .constant(""))
            .environmentObject(ModelData())
    }
}
