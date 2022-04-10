import SwiftUI
import PencilKit

struct CanvasView: View {
    @Environment(\.undoManager) private var undoManager
    @State private var canvasView = PKCanvasView()
    @Binding var toolPickerIsActive: Bool

    var body: some View {
        VStack {
            Spacer()
            HStack() {
                Button("Done") {
                    toolPickerIsActive.toggle()
                }
                .foregroundColor(.white)
                .padding(.leading, 30)
                Spacer()
                Button("Clear") {
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
            MyCanvas(canvasView: $canvasView, toolPickerIsActive: $toolPickerIsActive)
                .frame(height: 300)
        }
        .background(.gray)
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(.gray, lineWidth: 1)
        )
        .padding()
    }
}

struct MyCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var toolPickerIsActive: Bool
    
    @State var toolPicker = PKToolPicker()

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
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(toolPickerIsActive: .constant(true))
    }
}
