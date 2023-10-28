import SwiftUI
import SwiftData

struct CarouselView: View {
    
    private static var defaultAnimation = Animation.smooth
    
    @EnvironmentObject var modelData: ModelData
    @GestureState private var dragState = DragState.inactive
    @State private var indices:[Int] = []
    @State private var animation: Animation? = Self.defaultAnimation
    
    @Query(sort: [SortDescriptor(\Day.id)]) var days: [Day]
 
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(indices, id: \.self) { (idx) in
                    let offset = cellOffset(idx, geometry.size, false)
                    DayView(day: days[idx])
                        .offset(x: offset)
                        .animation(animation, value: offset)
                        .onTapGesture() {
                            withAnimation {
                                modelData.selectDay(Date().noon, days: days)
                                updateIndices()
                            }
                        }
                }
            }.onAppear {
                animation = nil
                if modelData.selectedDay == nil {
                    modelData.selectedIndex = currentIndex()
                    modelData.selectedDay = days[modelData.selectedIndex]
                }
                updateIndices()
            }
            /*.onChange(of: modelData.selectedIndex) {
                updateIndices()
            }*/
            .gesture(
                DragGesture()
                    .updating($dragState) { drag, state, transaction in
                        state = .dragging(translation: drag.translation)
                    }
                    .onChanged { _ in
                        if animation == nil {
                            animation = Self.defaultAnimation
                        }
                    }
                    .onEnded({ gesture in
                        onDragEnded(drag: gesture, geometry.size)
                    })
            )
        }
    }
    
    private func cellOffset(_ cellPosition: Int, _ size: CGSize, _ isScalable: Bool) -> CGFloat {
        
        let cellDistance: CGFloat = (size.width / (isScalable ? 0.87 : 1)) + 20
        
        if cellPosition == modelData.selectedIndex {
            // selected day
            return self.dragState.translation.width
        } else if cellPosition < modelData.selectedIndex {
            // Offset on the left
            let offset = self.dragState.translation.width - (cellDistance * CGFloat(modelData.selectedIndex - cellPosition))
            //print(offset)
            return offset
        } else {
            // Offset on the right
            let offset = self.dragState.translation.width + (cellDistance * CGFloat(cellPosition - modelData.selectedIndex))
            //print(offset)
            return offset
        }
    }
    
    private func onDragEnded(drag: DragGesture.Value, _ size: CGSize) {
        
        // The minimum dragging distance needed for changing between the cells
        let dragThreshold: CGFloat = size.width * 0.6
        
        if drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold {
            modelData.selectedIndex -= 1
        }
        else if (drag.predictedEndTranslation.width) < (-1 * dragThreshold) || (drag.translation.width) < (-1 * dragThreshold) {
            modelData.selectedIndex += 1
        }
        modelData.selectedDay = days[modelData.selectedIndex]
        updateIndices()
    }
    
    private func updateIndices() {
        var lowerIndex = modelData.selectedIndex - 2
        var upperIndex = modelData.selectedIndex + 2
        if lowerIndex < 0 {
            lowerIndex += 2
            upperIndex += 2
        } else if upperIndex+2 > days.count {
            lowerIndex -= 2
            upperIndex -= 2
        }
        indices = Array(lowerIndex...upperIndex)
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

enum DragState: Equatable {
    
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        
        if case let .dragging(translation) = self {
            return translation
        }
        return .zero
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
    }
}
