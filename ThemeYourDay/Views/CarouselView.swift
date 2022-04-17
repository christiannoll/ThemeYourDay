import SwiftUI

struct CarouselView: View {
    
    @EnvironmentObject var modelData: ModelData
    @GestureState private var dragState = DragState.inactive
    @State private var indices:[Int] = []
    @State private var dragAmount = DragState.inactive
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(indices, id: \.self) { (idx) in
                    DayView(day: $modelData.days[idx], isSelectedDay: cellLocation(idx)==idx ? true : false)
                        .offset(x: cellOffset(cellLocation(idx), geometry.size, false))
                        .animation(.easeInOut(duration: 1.0), value: dragState.translation)
                }
            }.onAppear {
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
            updateIndices()
        }
        else if (drag.predictedEndTranslation.width) < (-1 * dragThreshold) || (drag.translation.width) < (-1 * dragThreshold) {
            modelData.selectNextDay()
            updateIndices()
        }
    }
    
    private func updateIndices() {
        indices = Array(modelData.selectedIndex-2...modelData.selectedIndex+2)
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
