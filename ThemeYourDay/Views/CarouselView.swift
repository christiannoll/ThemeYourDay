import SwiftUI
import SwiftData

struct CarouselView: View {

    @Environment(ModelData.self) var modelData
    @Query(sort: [SortDescriptor(\Day.id)]) var days: [Day]
 
    var body: some View {
        ScrollViewReader { value in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(Array(days.enumerated()), id: \.offset) { idx, day in
                        DayView(day: day)
                            .frame(width: .screenWidth - 10)
                            .id(idx)
                            .onTapGesture() {
                                withAnimation {
                                    selectToday()
                                    value.scrollTo(modelData.selectedIndex)
                                }
                            }
                    }.onAppear {
                        value.scrollTo(modelData.selectedIndex)
                    }
                    .padding(.horizontal, 5)
                }.onAppear {
                    if modelData.selectedDay == nil {
                        selectToday()
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .onScrollTargetVisibilityChange(idType: Int.self) { identifiers in
                if let currentId = identifiers.first {
                    modelData.selectedIndex = currentId
                    modelData.selectedDay = days[modelData.selectedIndex]
                }
            }
        }
    }

    private func selectToday() {
        modelData.selectedIndex = currentIndex()
        modelData.selectedDay = days[modelData.selectedIndex]
    }

    private func currentIndex() -> Int {
        let today = Date().noon
        var index = -1
        for day in days {
            index += 1
            if day.id.hasSame(.day, as: today) {
                break
            }
        }
        return index
    }
}

extension CGFloat {
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
}

#Preview {
    CarouselView()
        .environment(ModelData())
}
