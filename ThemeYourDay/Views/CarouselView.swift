import SwiftUI

struct CarouselView: View {
    
    @EnvironmentObject var modelData: ModelData
    @GestureState private var dragState = DragState.inactive
    @State private var isMovedLeft: Bool = false
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                /*DayView(day: $modelData.dayBefore, isSelectedDay: false)
                    .offset(x: cellOffset(-1, geometry.size, true))
                    //.scaleEffect(0.9)
                    //.animation(.easeInOut(duration: 0.1))
                DayView(day: $modelData.selectedDay, isSelectedDay: true)
                    .offset(x: cellOffset(0, geometry.size, false))
                    //.animation(.easeInOut(duration: 0.1))
                DayView(day: $modelData.dayAfter, isSelectedDay: false)
                    .offset(x: cellOffset(1, geometry.size, true))
                    //.scaleEffect(0.9)
                    //.animation(.easeInOut(duration: 0.1))*/
                ForEach(0..<modelData.days.count) { (idx) in
                    DayView(day: $modelData.days[idx], isSelectedDay: cellLocation(idx)==idx ? true : false)
                        .offset(x: cellOffset(cellLocation(idx), geometry.size, idx == modelData.selectedIndex))
                        .scaleEffect(idx == modelData.selectedIndex ? 1.0 : 0.9)
                        .animation(.easeInOut(duration: 0.2), value: idx == modelData.selectedIndex ? 1.0 : 0.9)
                }
            }
            .gesture(
                DragGesture()
                    .updating($dragState) { drag, state, transaction in
                        state = .dragging(translation: drag.translation)
                    }
                    .onChanged({ gesture in
                        dragHappening(drag: gesture)
                    })
                    .onEnded({ gesture in
                        onDragEnded(drag: gesture, geometry.size)
                    })
            )
        }
        .aspectRatio(contentMode: .fit)
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
        
        if (modelData.selectedIndex == 0) && (idx + 1 == modelData.days.count) {
            // The cell is on the left side
            return -1
        } else if (modelData.selectedIndex == modelData.days.count - 1) && (idx == 0) {
            // The cell is on the right side
            return modelData.days.count
        } else {
            // The main cell
            return idx
        }
    }
    
    private func onDragEnded(drag: DragGesture.Value, _ size: CGSize) {
        
        // The minimum dragging distance needed for changing between the cells
        let dragThreshold: CGFloat = size.width * 0.6
        
        if drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold {
            modelData.selectDayBefore()
            //modelData.selectedIndex -= 1
        }
        else if (drag.predictedEndTranslation.width) < (-1 * dragThreshold) || (drag.translation.width) < (-1 * dragThreshold) {
            modelData.selectNextDay()
            //modelData.selectedIndex += 1
        }
    }
    
    private func dragHappening(drag: DragGesture.Value) {
        if drag.startLocation.x > drag.location.x {
            isMovedLeft = true
        } else {
            isMovedLeft = false
        }
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
