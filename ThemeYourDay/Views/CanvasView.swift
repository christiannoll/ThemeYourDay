import SwiftUI
import SwiftData
import PencilKit

struct CanvasView: View {
    @Environment(\.undoManager) private var undoManager
    @Environment(ModelData.self) var modelData
    @Environment(\.modelContext) private var context
    @State private var canvasView = PKCanvasView()
    @Binding var toolPickerIsActive: Bool
    
    @Query() var settings: [Settings]
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?

    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 20) {
                Button(action: {
                    saveImage()
                    savePngImage()
                    toolPickerIsActive.toggle()
                }) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                }
                .accessibilityLabel("Done")
                .padding(.leading, 30)
                Spacer()
                Button(action: {
                    deleteImage()
                    canvasView.drawing = PKDrawing()
                }) {
                    Image(systemName: "trash.circle.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                }
                .accessibilityLabel("Clear")
                Button(action: {
                    undoManager?.undo()
                }) {
                    Image(systemName: "arrow.uturn.backward.circle.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                }
                .accessibilityLabel("Undo")
                Button(action: {
                    undoManager?.redo()
                }) {
                    Image(systemName: "arrow.uturn.forward.circle.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                }
                .accessibilityLabel("Redo")
                .padding(.trailing, 30)
            }
            .frame(height: 28)
            Spacer()
            if let day = modelData.selectedDay {
                MyCanvas(canvasView: $canvasView, toolPickerIsActive: $toolPickerIsActive, backgroundColor: day.bgColor.color)
                    .frame(height: getHeight())
                    .overlay(textOverlay.allowsHitTesting(false))
                    .modifier(StickerOverlay(day: day))
            }
        }
        .onAppear { loadImage() }
        .background(.gray)
        .cornerRadius(25) 
        .padding()
    }

    var isLandscape: Bool {
        verticalSizeClass == .compact
    }

    private func getHeight() -> CGFloat {
        ContentView.getHeight(horizontalSizeClass, verticalSizeClass, isLandscape)
    }
    
    @ViewBuilder
    private var textOverlay: some View {
        if let day = modelData.selectedDay, let mySettings = settings.first {
            Text(day.text)
                .font(day.fontname == "" ? day.font() : .custom(day.fontname, size: 34))
                .foregroundColor(day.fgColor.color)
                .multilineTextAlignment(day.getTextAlignment())
                .padding(.horizontal, 36)
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
            if let data = image.pngData(), let day = modelData.selectedDay {
                modelData.savePngImageOfSelectedDay(data: data)
                day.hasImage = true
                modelData.save(context)
                modelData.informWidget()
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
            if modelData.selectedDay != nil {
                modelData.selectedDay?.hasImage = false
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

#Preview {
    CanvasView(toolPickerIsActive: .constant(true))
}
