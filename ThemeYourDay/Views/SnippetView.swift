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
                    VStack {
                        Spacer()
                        HStack {
                            Text(snippet.text)
                            Spacer()
                        }
                        HStack {
                            Text(snippet.author)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        Divider()
                            .padding(.vertical, 4)
                    }
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        modelData.selectedDay.text = snippet.text
                        modelData.save()
                    }
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
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
