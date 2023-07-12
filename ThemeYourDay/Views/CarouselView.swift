import SwiftUI
import SwiftData

struct CarouselView: View {
    
    @EnvironmentObject var modelData: ModelData
    @GestureState private var dragState = DragState.inactive
    @State private var indices:[Int] = []
    @State private var dragAmount = DragState.inactive
    
    @Query(sort: [SortDescriptor(\.id)]) var days: [MyDay]
 
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(indices, id: \.self) { (idx) in
                    DayView(day: days[idx], isSelectedDay: cellLocation(idx)==idx ? true : false)
                        .offset(x: cellOffset(cellLocation(idx), geometry.size, false))
                        .animation(.easeInOut(duration: 0.7), value: dragState.translation)
                        .onTapGesture() {
                            withAnimation {
                                modelData.selectDay(Date().noon)
                                updateIndices()
                            }
                        }
                }
            }.onAppear {
                modelData.selectedIndex = currentIndex()
                modelData.selectedMyDay = days[modelData.selectedIndex]
                updateIndices()
            }
            .gesture(
                DragGesture()
                    .updating($dragState) { drag, state, transaction in
                        state = .dragging(translation: drag.translation)
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
    
    private func cellLocation(_ idx: Int) -> Int {
        
        if (modelData.selectedIndex == 0) && (idx + 1 == days.count) {
            // The cell is on the left side
            return -1
        } else if (modelData.selectedIndex == days.count - 1) && (idx == 0) {
            // The cell is on the right side
            return days.count
        } else {
            // The main cell
            return idx
        }
    }
    
    private func onDragEnded(drag: DragGesture.Value, _ size: CGSize) {
        
        // The minimum dragging distance needed for changing between the cells
        let dragThreshold: CGFloat = size.width * 0.6
        
        if drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold {
            //modelData.selectDayBefore()
            modelData.selectedIndex -= 1
            modelData.selectedMyDay = days[modelData.selectedIndex]
            updateIndices()
        }
        else if (drag.predictedEndTranslation.width) < (-1 * dragThreshold) || (drag.translation.width) < (-1 * dragThreshold) {
            //modelData.selectNextDay()
            modelData.selectedIndex += 1
            modelData.selectedMyDay = days[modelData.selectedIndex]
            updateIndices()
        }
    }
    
    private func updateIndices() {
        indices = Array(modelData.selectedIndex-2...modelData.selectedIndex+2)
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

enum DragState {
    
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
