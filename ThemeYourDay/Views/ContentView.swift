import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var themetext = "..."
    
    init() {
        //_themetext = State(initialValue: ModelData().days[0].text)
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text(getDate())
                .background(Color.gray)
                .foregroundColor(.white)
                
            TextEditor(text: $themetext)
                .font(.largeTitle)
                .background(Color(red: 153/255, green: 204/255, blue: 255/255))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .lineSpacing(20)
                .onAppear {
                    themetext = modelData.selectedDay.text
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
                    }))
        }
        .background(Color.gray)
        .cornerRadius(25.0)
        .frame(height: 400)
        .padding()
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
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
