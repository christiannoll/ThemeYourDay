import SwiftUI
import SwiftData

struct DayView: View {
    
    @Environment(ModelData.self) var modelData
    @FocusState private var focusMode: Bool
    @Bindable var day: Day
    var readOnly = false
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        VStack {
            Spacer()
            Text(getDate())
                .background(.gray)
                .foregroundColor(.white)
            Spacer()
            
            if readOnly {
                Text(day.text)
                    .padding()
                    .frame(width: 392, height: getHeight(), alignment: .top)
                    .background(day.hasImage ? Image(uiImage: loadPngImage()) : Image(uiImage: UIImage()))
                    .modifier(DayViewTextStyle(day: day))
                    .modifier(StickerOverlay(day: day))
            } else {
                TextEditor(text: $day.text)
                    .scrollDisabled(true)
                    .padding()
                    .frame(height: getHeight())
                    .background(day.hasImage ? Image(uiImage: loadPngImage()) : Image(uiImage: UIImage()))
                    .modifier(DayViewTextStyle(day: day))
                    .highPriorityGesture(
                        TapGesture().onEnded {
                            focusMode = !focusMode
                            modelData.informWidget()
                        }
                    )
                    .focused($focusMode)
                    .modifier(StickerOverlay(day: day))
            }
        }
        .background(.gray)
        .cornerRadius(25.0)
        .padding()
        .overlay(starOverlay, alignment: .topTrailing)
    }
    
    private func loadPngImage() -> UIImage {
        do {
            let data = try Data(contentsOf: modelData.getPngImageFilename(date: day.id), options: [.mappedIfSafe, .uncached])
            let drawing = UIImage(data: data)
            return drawing!
        } catch {
            return UIImage()
        }
    }
    
    private var starOverlay: some View {
        Image(systemName: day.starred ? "star.fill" : "star")
            .foregroundColor(.white)
            .padding(.top, readOnly ? 24 : 28)
            .padding(.trailing, 32)
            .onTapGesture {
                day.starred.toggle()
            }
    }
    
    private func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateString = formatter.string(from: day.id)
        let weekday = formatter.weekdaySymbols[Calendar.current.component(.weekday, from: day.id) - 1]

        return weekday + " " + dateString
    }
    
    private func getHeight() -> CGFloat {
        ContentView.getHeight(horizontalSizeClass, verticalSizeClass)
    }
}

struct DayViewTextStyle: ViewModifier {
    
    @Environment(ModelData.self) var modelData
    @Query() var settings: [Settings]
    var day: Day
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        content
            .font(day.fontname == "" ? day.font() : .custom(day.fontname, size: 34))
            .multilineTextAlignment(day.getTextAlignment())
            .scrollContentBackground(.hidden)
            .background(day.bgColor.color)
            .foregroundColor(day.fgColor.color)
            .disableAutocorrection(true)
            .lineSpacing(CGFloat(lineSpacing()))
    }
    
    private func lineSpacing() -> Int {
        if let mySettings = settings.first {
            return mySettings.textLineSpacing
        }
        return 10
    }
}

struct StickerOverlay: ViewModifier {
    
    @Environment(ModelData.self) var modelData
    var day: Day
    
    public func body(content: Content) -> some View {
        content
            .if (!day.sticker.name.isEmpty) { view in
                view.overlay(
                    Image(day.sticker.name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 80)
                        .padding(.bottom, 40)
                        .onLongPressGesture(minimumDuration: 1) {
                            removeSticker()
                        },
                    alignment: .bottom
                )
            }
    }
    
    private func removeSticker() {
        modelData.selectedDay?.sticker.name = ""
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(day: Day(id: Date().noon, text: "Today", fgColor: DayColor()))
            .environment(ModelData())
    }
}
