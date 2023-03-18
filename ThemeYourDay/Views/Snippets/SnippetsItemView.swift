//
//  SnippetsItemView.swift
//  ThemeYourDay
//
//  Created by Christian on 18.03.23.
//

import SwiftUI

struct SnippetsItemView: View {
    
    let snippet: Snippet
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
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
            modelData.selectedDay.textStyle = snippet.textSytle()
            modelData.save()
        }
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listRowSeparator(.hidden)
    }
}

struct SnippetsItemView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetsItemView(snippet: Snippet())
    }
}
