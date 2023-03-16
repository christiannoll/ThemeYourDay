//
//  StickerView.swift
//  ThemeYourDay
//
//  Created by Christian on 10.03.23.
//

import SwiftUI

struct StickerView: View {
    
    @EnvironmentObject var modelData: ModelData
    
    private var gridItemLayout = [GridItem(.adaptive(minimum: 50))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                ForEach(modelData.stickers, id: \.self) {
                    let sticker = $0
                    Image(sticker.name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 50)
                        .onTapGesture {
                            modelData.selectedDay.sticker.name = sticker.name
                            modelData.selectedDay.sticker.category = sticker.category
                            modelData.save()
                        }
                }
            }
            .padding(.horizontal)
            .padding(.top, 50)
        }
    }
}

struct StickerView_Previews: PreviewProvider {
    static var previews: some View {
        StickerView()
    }
}
