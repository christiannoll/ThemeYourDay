import SwiftUI

struct SnippetsView: View {
    
    let category: Category
    @Environment(ModelData.self) var modelData
    
    private var filteredSnippets: [Snippet] {
        let result = modelData.snippets.filter {
            $0.category == category
        }
        return result
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(filteredSnippets, id: \.self) { snippet in
                    SnippetsItemView(snippet: snippet)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.inset)
        }
    }
}

#Preview {
    SnippetsView(category: .philosophy)
}
