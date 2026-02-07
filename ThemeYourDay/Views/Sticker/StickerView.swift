import SwiftUI

struct StickerView: View {
    
    @Environment(ModelData.self) var modelData
    @State private var category: Category = .animal
    
    var body: some View {
        VStack(alignment: .leading) {
            StickerHeaderView(category: $category)
                .padding([.leading, .trailing, .bottom], 8)
                .padding(.top, 18)
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
