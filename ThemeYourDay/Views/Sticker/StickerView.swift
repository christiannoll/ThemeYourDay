//
//  StickerView.swift
//  ThemeYourDay
//
//  Created by Christian on 10.03.23.
//

import SwiftUI

struct StickerView: View {
    
    @EnvironmentObject var modelData: ModelData
    @State private var category: Category = .animal
    
    var body: some View {
        VStack(alignment: .leading) {
            StickerHeaderView(category: $category)
                .padding(8)
            TabView(selection: $category) {
                StickerCategoryView(category: .animal)
                    .tag(Category.animal)
                StickerCategoryView(category: .general)
                    .tag(Category.general)
                StickerCategoryView(category: .flower)
                    .tag(Category.flower)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .padding(.horizontal)
    }
}

struct StickerView_Previews: PreviewProvider {
    static var previews: some View {
        StickerView()
    }
}
