//
//  StickerView.swift
//  ThemeYourDay
//
//  Created by Christian on 10.03.23.
//

import SwiftUI

struct StickerView: View {
    
    @EnvironmentObject var modelData: ModelData
    
    private let stickers = ["Android", "BoxingKangaroo", "CuteElephant", "HappyBaby", "HappyPanda", "LazyBear", "LazyBear2", "LazyBear3", "PandaFace", "PinkElephant", "SmilingAlien"]
    private var gridItemLayout = [GridItem(.adaptive(minimum: 50))]//[GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                ForEach(stickers, id: \.self) {
                    let sticker: String = $0
                    Image(sticker)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 50)
                        .onTapGesture {
                            modelData.selectedDay.sticker.stickerName = sticker
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
