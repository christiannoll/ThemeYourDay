//
//  SnippetsView.swift
//  ThemeYourDay
//
//  Created by Christian on 16.03.23.
//

import SwiftUI

struct SnippetsView: View {
    
    let category: Category
    @EnvironmentObject var modelData: ModelData
    
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

struct SnippetView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetsView(category: .philosophy)
    }
}
