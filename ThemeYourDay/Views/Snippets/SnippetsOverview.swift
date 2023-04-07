//
//  SnippetsOverview.swift
//  ThemeYourDay
//
//  Created by Christian on 18.03.23.
//

import SwiftUI

struct SnippetsOverview: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Texte")) {
                    NavigationLink("Philosophische Texte", destination: SnippetsView(category: .philosophy))
                    NavigationLink("Lateinische Sprüche", destination: SnippetsView(category: .latin))
                    NavigationLink("Lebensweisheiten", destination: SnippetsView(category: .lifewisdom))
                    NavigationLink("Happiness", destination: SnippetsView(category: .happiness))
                }
            }
        }
    }
}

struct SnippetsOverview_Previews: PreviewProvider {
    static var previews: some View {
        SnippetsOverview()
    }
}
