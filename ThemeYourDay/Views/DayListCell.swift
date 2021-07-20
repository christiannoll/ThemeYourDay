import SwiftUI

struct DayListCell: View {
    var day: Day
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(day.bgColor.color)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 4)
                .shadow(color: Color.black, radius: 3, x: 3, y: 3)

            VStack {
                Text(getTrimmedText(day))
                    .foregroundColor(day.fgColor.color)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .lineLimit(1)
                Text(getDate(day))
                    .foregroundColor(day.bgColor.invert())
            }
            .padding()
        }
    }
    
    private func getDate(_ day: Day) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        //formatter.setLocalizedDateFormatFromTemplate("dd MM yyyy")
        let dateString = formatter.string(from: day.id)
        return dateString
    }
    
    private func getTrimmedText(_ day: Day) -> String {
        day.text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).joined()
    }
}

struct DayListCell_Previews: PreviewProvider {
    static var previews: some View {
        DayListCell(day: Day(id: Date(), text: "Today", fgColor: DayColor()))
    }
}
