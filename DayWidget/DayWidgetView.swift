import SwiftUI

struct DayWidgetView: View {
    
    let day: Day
    
    var padding: CGFloat = 5
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.gray)
                .overlay(
                    Text(formattedDate())
                        .foregroundColor(.white)
                )
                .frame(height:30)
                .cornerRadius(50, corners: [.topLeft, .topRight])
                
            Text(day.text)
                .font(day.fontname == "" ? .title2 : .custom(day.fontname, size: 20))
                .background(day.bgColor.color)
                .foregroundColor(day.fgColor.color)
                .multilineTextAlignment(.center)
                .lineSpacing(20)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ContainerRelativeShape().fill(day.bgColor.color))
        .padding(padding)
    }
    
    private func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d. MMM y"
        
        return dateFormatter.string(from: day.id)
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
