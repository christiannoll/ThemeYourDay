//
//  SnippetView.swift
//  ThemeYourDay
//
//  Created by Christian on 16.03.23.
//

import SwiftUI

struct SnippetView: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(modelData.snippets, id: \.self) { snippet in
                    SnippetsItemView(snippet: snippet)
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}

struct SnippetView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetView()
    }
}
