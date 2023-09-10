import SwiftUI
import SwiftData
import PencilKit

struct CanvasView: View {
    @Environment(\.undoManager) private var undoManager
    @EnvironmentObject var modelData: ModelData
    @State private var canvasView = PKCanvasView()
    @Binding var toolPickerIsActive: Bool
    
    @Query() var settings: [MySettings]
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?

    var body: some View {
        VStack {
            Spacer()
            HStack() {
                Button(.done) {
                    saveImage()
                    savePngImage()
                    toolPickerIsActive.toggle()
                }
                .foregroundColor(.white)
                .padding(.leading, 30)
                Spacer()
                Button(.clear) {
                    deleteImage()
                    canvasView.drawing = PKDrawing()
                }
                .foregroundColor(.white)
                Button(.undo) {
                    undoManager?.undo()
                }
                .foregroundColor(.white)
                Button(.redo) {
                    undoManager?.redo()
                }
                .foregroundColor(.white)
                .padding(.trailing, 30)
            }
            .frame(height: 28)
            Spacer()
            if let day = modelData.selectedMyDay {
                MyCanvas(canvasView: $canvasView, toolPickerIsActive: $toolPickerIsActive, backgroundColor: day.bgColor.color)
                    .frame(height: getHeight())
                    .overlay(textOverlay.allowsHitTesting(false))
            }
        }
        .onAppear { loadImage() }
        .background(.gray)
        .cornerRadius(25) 
        .padding()
    }
    
    private func getHeight() -> CGFloat {
        ContentView.getHeight(horizontalSizeClass, verticalSizeClass)
    }
    
    @ViewBuilder
    private var textOverlay: some View {
        if let day = modelData.selectedMyDay, let mySettings = settings.first {
            Text(day.text)
                .font(day.fontname == "" ? day.font() : .custom(day.fontname, size: 34))
                .foregroundColor(day.fgColor.color)
                .multilineTextAlignment(day.getTextAlignment())
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
                .frame(width: 392, height: getHeight(), alignment: day.getAlignment())
                .lineSpacing(CGFloat(mySettings.textLineSpacing))
        }
    }
    
    private func saveImage() {
        if canvasView.drawing.bounds.isEmpty == false {
            modelData.saveImageOfSelectedDay(imageData: canvasView.drawing.dataRepresentation())
        }
    }
    
    private func savePngImage() {
        if canvasView.drawing.bounds.isEmpty == false {
            let imgRect = CGRect(x: 0, y: 0, width: canvasView.bounds.width, height: canvasView.bounds.height)
            let image = canvasView.drawing.image(from: imgRect, scale: 1.0)
            if let data = image.pngData(), let day = modelData.selectedMyDay {
                modelData.savePngImageOfSelectedDay(data: data)
                day.hasImage = true
            }
        }
    }
    
    private func loadImage() {
        if let imageData = modelData.loadImageOfSelectedDay() {
            do {
                try canvasView.drawing = PKDrawing(data: imageData)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func deleteImage() {
        if canvasView.drawing.bounds.isEmpty == false {
            modelData.deleteImageOfSelectedDay()
            if modelData.selectedMyDay != nil {
                modelData.selectedMyDay?.hasImage = false
            }
            modelData.informWidget()
        }
    }
}

struct MyCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var toolPickerIsActive: Bool
    
    @State var toolPicker = PKToolPicker()
    var backgroundColor: Color

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        showToolPicker()
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        toolPicker.setVisible(toolPickerIsActive, forFirstResponder: canvasView)
    }
}

private extension MyCanvas {
    func showToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        canvasView.backgroundColor = UIColor(backgroundColor)
        canvasView.isOpaque = false
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(toolPickerIsActive: .constant(true))
    }
}
