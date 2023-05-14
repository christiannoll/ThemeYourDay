//
//  StickerCategoryView.swift
//  ThemeYourDay
//
//  Created by Christian on 11.04.23.
//

import SwiftUI

struct StickerCategoryView: View {
    
    var gridItemLayout = [GridItem(.adaptive(minimum: 50))]
    @EnvironmentObject var modelData: ModelData
    
    let category: Category
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 12) {
                ForEach(modelData.stickers, id: \.self) {
                    let sticker = $0
                    if sticker.category == category {
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
            }
        }
        .animation(.interactiveSpring(), value: category)
    }
}

struct StickerCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        StickerCategoryView(category: .animal)
    }
}
