import SwiftUI

struct DayView: View {
    
    @EnvironmentObject var modelData: ModelData
    @FocusState private var focusMode: Bool
    @Binding var day: Day
    var isSelectedDay: Bool
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
                    .padding()
                    .frame(height: getHeight())
                    .background(day.hasImage ? Image(uiImage: loadPngImage()) : Image(uiImage: UIImage()))
                    .modifier(DayViewTextStyle(day: day))
                    .onTapGesture {
                        focusMode = !focusMode
                    }
                    .focused($focusMode)
                    .onChange(of: day.text, perform: saveText)
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
                modelData.selectedDay.starred = !day.starred
                modelData.save()
            }
    }
    
    private func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateString = formatter.string(from: day.id)
        let weekday = formatter.weekdaySymbols[Calendar.current.component(.weekday, from: day.id) - 1]

        return weekday + " " + dateString
    }
    
    private func saveText(_ text: String) {
        if modelData.days[modelData.selectedIndex] == day {
            modelData.selectedDay.text = text
            //print(text)
            modelData.save()
        }
    }
    
    private func removeSticker() {
        if modelData.days[modelData.selectedIndex] == day {
            modelData.selectedDay.sticker.stickerName = ""
            modelData.save()
        }
    }
    
    private func getHeight() -> CGFloat {
        ContentView.getHeight(horizontalSizeClass, verticalSizeClass)
    }
}

struct DayViewTextStyle: ViewModifier {
    
    @EnvironmentObject var modelData: ModelData
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
            .lineSpacing(CGFloat(modelData.settings.textLineSpacing))
    }
}

struct StickerOverlay: ViewModifier {
    
    @EnvironmentObject var modelData: ModelData
    var day: Day
    
    public func body(content: Content) -> some View {
        content
            .if (!day.sticker.stickerName.isEmpty) { view in
                view.overlay(
                    Image(day.sticker.stickerName)
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
        if modelData.days[modelData.selectedIndex] == day {
            modelData.selectedDay.sticker.stickerName = ""
            modelData.save()
        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(day:.constant(Day(id: Date().noon, text: "Today", fgColor: DayColor())), isSelectedDay: false)
            .environmentObject(ModelData())
    }
}
