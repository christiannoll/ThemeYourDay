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
            TextEditor(text: $themetext)
                .padding()
                .font(.largeTitle)
                .background(Color.red)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .lineSpacing(20)
                .onAppear {
                    themetext = modelData.days[0].text
                }
            Spacer()
        }
        .background(Color.red)
        .cornerRadius(25.0)
        .frame(height: 400)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
