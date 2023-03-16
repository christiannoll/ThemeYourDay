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
        ScrollView {
            ForEach(modelData.snippets, id: \.self) { snippet in
                HStack {
                    Text(snippet.text)
                    Spacer()
                }
                .padding(.vertical, 7)
                .onTapGesture {
                    modelData.selectedDay.text = snippet.text
                    modelData.save()
                }
            }
            .padding()
        }
    }
}

struct SnippetView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetView()
    }
}
