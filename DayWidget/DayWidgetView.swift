import SwiftUI

struct DayWidgetView: View {
    
    let day: Day
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.gray)
                .overlay(
                    Text(formattedDate())
                        .foregroundColor(.white)
                        .font(.caption)
                )
                .frame(height:26)
                .cornerRadius(50, corners: [.topLeft, .topRight])
                .overlay (starOverlay
                    .foregroundColor(.white)
                    .padding(.trailing, 8)
                    .padding(.top, 3), alignment: .topTrailing)
            
            Text(day.text)
                .padding(.horizontal, 6)
                .frame(width: 170, height: 130, alignment: day.getAlignment())
                .font(day.fontname == "" ? .caption : .custom(day.fontname, size: 16))
                .background(backgroundImage
                    .resizable()
                    .frame(width: 170, height: 148))
                .background(day.bgColor.color)
                .foregroundColor(day.fgColor.color)
                .lineSpacing(15)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ContainerRelativeShape().fill(day.bgColor.color))
    }
    
    private func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d. MMM y"
        
        return dateFormatter.string(from: day.id)
    }
    
    private var starOverlay: some View {
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


struct DayWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        DayWidgetView(day: Day(id: Date(), text: "Today", fgColor: DayColor()))
    }
}
