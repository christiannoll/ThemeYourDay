import SwiftUI

struct ContentView: View {
    @State private var themetext = "Theme your day ..."
    
    init() {
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
    }
}
