import SwiftUI

struct DayWidgetView: View {
    
    let day: Day
    @Environment(\.widgetFamily) private var widgetFamily
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.gray)
                .overlay(
                    Text(formattedDate())
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding(.top, 12)
                )
                .frame(height:36)
                .cornerRadius(50, corners: [.topLeft, .topRight])
                .overlay (starOverlay
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 12, height: 12)
                    .padding(.trailing, 18)
                    .padding(.top, 18), alignment: .topTrailing)
            
            Text(day.text)
                .padding(.horizontal, 6)
                .frame(width: getTextFrameWidth(), height: getTextFrameHeight(), alignment: .top)
                .font(getFont())
                .background(backgroundImage
                    .resizable()
                    .frame(width: 170, height: 148))
                .background(day.bgColor.color)
                .foregroundColor(day.fgColor.color)
                //.multilineTextAlignment(day.getTextAlignment())
                .lineSpacing(4)
                .lineLimit(day.sticker.name.isEmpty ? 6  : 4)
                .if (!day.sticker.name.isEmpty) { view in
                    view.overlay(
                        Image(day.sticker.name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 50)
                            .padding(.bottom, 10),
                        alignment: .bottom
                    )
                }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ContainerRelativeShape().fill(day.bgColor.color))
        .containerBackground(.red.gradient, for: .widget)
    }
    
    private func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d. MMM y"
        
        return dateFormatter.string(from: day.id)
    }
    
    private var starOverlay: Image {
        day.starred ? Image(systemName: "star.fill") : Image(uiImage: UIImage())
    }
    
    private var backgroundImage: Image {
        day.hasImage ? Image(uiImage: loadPngImage()) : Image(uiImage: UIImage())
    }
    
    private func loadPngImage() -> UIImage {
        do {
            let data = try Data(contentsOf: getPngImageFileUrl(date: day.id), options: [.mappedIfSafe, .uncached])
            let drawing = UIImage(data: data)
            return drawing!
        } catch {
            return UIImage()
        }
    }
    
    private func getFont() -> Font {
        switch widgetFamily {
        case .systemLarge, .systemExtraLarge:
            return day.fontname == "" ? Font.title : .custom(day.fontname, size: 26)
        case .systemMedium:
            return day.fontname == "" ? Font.headline : .custom(day.fontname, size: 22)
        default:
            return day.fontname == "" ? Font.caption : .custom(day.fontname, size: 16)
        }
    }
    
    private func getTextFrameWidth() -> CGFloat {
        switch widgetFamily {
        case .systemMedium, .systemLarge, .systemExtraLarge:
            return 300
        default:
            return 160
        }
    }
    
    private func getTextFrameHeight() -> CGFloat {
        switch widgetFamily {
        case .systemLarge, .systemExtraLarge:
            return 300
        default:
            return 130
        }
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct DayWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        DayWidgetView(day: Day(id: Date(), text: "Today", fgColor: DayColor()))
    }
}
