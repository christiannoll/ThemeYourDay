//
//  StickerHeaderView.swift
//  ThemeYourDay
//
//  Created by Christian on 14.05.23.
//

import SwiftUI

struct StickerHeaderView: View {
    @Binding var category: Category
    
    struct StickerCategory: Identifiable {
        let id: Category
        let icon: String
    }
    private let stickerCategories: [StickerCategory] = [StickerCategory(id: .animal, icon: "pawprint"),
                                                        StickerCategory(id: .general, icon: "person"),
                                                        StickerCategory(id: .flower, icon: "leaf")]
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(stickerCategories) { stickerCategory in
                Button {
                    category = stickerCategory.id
                } label: {
                    Image(systemName: stickerCategory.icon)
                        .foregroundColor(category == stickerCategory.id ? .white: .secondary)
                        .frame(width: 30, height: 30)
                        .background(category == stickerCategory.id ? .gray: .clear)
                        .clipShape(Circle())
                }
            }
        }
    }
}

struct StickerHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        StickerHeaderView(category: .constant(.animal))
    }
}
