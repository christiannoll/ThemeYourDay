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
        UIScreen.current?.bounds.width ?? 0
    }
}

extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}


extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}


#Preview {
    CarouselView()
        .environment(ModelData())
}
