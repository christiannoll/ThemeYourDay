import SwiftUI
import PencilKit

struct CanvasView: View {
    @Environment(\.undoManager) private var undoManager
    @EnvironmentObject var modelData: ModelData
    @State private var canvasView = PKCanvasView()
    @Binding var toolPickerIsActive: Bool

    var body: some View {
        VStack {
            Spacer()
            HStack() {
                Button("Done") {
                    saveImage()
                    savePngImage()
                    toolPickerIsActive.toggle()
                }
                .foregroundColor(.white)
                .padding(.leading, 30)
                Spacer()
                Button("Clear") {
                    deleteImage()
                    canvasView.drawing = PKDrawing()
                }
                .foregroundColor(.white)
                Button("Undo") {
                    undoManager?.undo()
                }
                .foregroundColor(.white)
                Button("Redo") {
                    undoManager?.redo()
                }
                .foregroundColor(.white)
                .padding(.trailing, 30)
            }
            .frame(height: 28)
            Spacer()
            MyCanvas(canvasView: $canvasView, toolPickerIsActive: $toolPickerIsActive, backgroundColor: modelData.selectedDay.bgColor.color)
                .frame(height: 300)
                .overlay(textOverlay)
        }
        .onAppear { loadImage() }
        .background(.gray)
        .cornerRadius(25) 
        .padding()
    }
    
    private var textOverlay: some View {
        let day = modelData.selectedDay
        return Text(day.text)
            .font(day.fontname == "" ? day.font() : .custom(day.fontname, size: 34))
            .foregroundColor(day.fgColor.color)
            .multilineTextAlignment(day.getTextAlignment())
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .frame(width: 392, height: 300, alignment: day.getAlignment())
            .lineSpacing(CGFloat(modelData.settings.textLineSpacing))
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
            if let data = image.pngData() {
                modelData.savePngImageOfSelectedDay(data: data)
                modelData.selectedDay.hasImage = true
                modelData.save()
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
            modelData.selectedDay.hasImage = false
            modelData.save()
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
