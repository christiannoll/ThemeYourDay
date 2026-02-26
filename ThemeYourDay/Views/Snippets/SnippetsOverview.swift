import SwiftUI

struct SnippetsOverview: View {
    
    @Environment(ModelData.self) var modelData
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Texte")) {
                    NavigationLink("Philosophische Texte", destination: SnippetsView(category: .philosophy))
                    NavigationLink("Lateinische Sprüche", destination: SnippetsView(category: .latin))
                    NavigationLink("Lebensweisheiten", destination: SnippetsView(category: .lifewisdom))
                    NavigationLink("Happiness", destination: SnippetsView(category: .happiness))
                }
                .listRowBackground(Color.clear)
            }
            .padding(.top, 10)
        }
    }
}

#Preview {
    SnippetsOverview()
}
