import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var themetext = "..."
    @State private var fgColor = Color.white
    @State private var showingColor = false
    
    init() {
        //_themetext = State(initialValue: ModelData().days[0].text)
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack(alignment: .center) {
                    Spacer()
                    Text(getDate())
                        .background(Color.gray)
                        .foregroundColor(.white)
                        
                    TextEditor(text: $themetext)
                        .font(.largeTitle)
                        .background(Color(red: 153/255, green: 204/255, blue: 255/255))
                        .foregroundColor(fgColor)
                        .multilineTextAlignment(.center)
                        .disableAutocorrection(true)
                        .lineSpacing(20)
                        .onAppear {
                            themetext = modelData.selectedDay.text
                            fgColor = getTextColor()
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
                            }))
                }
                .background(Color.gray)
                .cornerRadius(25.0)
                .frame(height: 400)
                .padding()
            
                Spacer()
                
                ColorPicker("Color", selection: $fgColor)
                    .labelsHidden()
                    .onChange(of: fgColor) {newValue in
                        saveFgColor(newValue)
                    }
                    .opacity(showingColor ? 1 : 0)
                    .padding()
            }
            
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { showingColor.toggle() }) {
                        Image(systemName: "textformat")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { }) {
                        Image(systemName: "note")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
            }
        }
    }
    
    private func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: modelData.selectedDay.id)
        return dateString
    }
    
    private func saveText(_ text: String) {
        modelData.selectedDay.text = text
        modelData.writeJSON()
    }
    
    private func saveFgColor(_ fgColor: Color) {
        let uiColor = UIColor(fgColor)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        modelData.saveFgColor(r: Double(red), g: Double(green), b: Double(blue), a: Double(alpha))
        modelData.writeJSON()
    }
    
    private func getTextColor() -> Color {
        return Color(red:modelData.selectedDay.fgColor.r, green:modelData.selectedDay.fgColor.g, blue:modelData.selectedDay.fgColor.b, opacity:modelData.selectedDay.fgColor.a)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
