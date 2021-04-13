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

            HStack {
                Text(getDate(day))
                Text(day.text)
                    .foregroundColor(day.fgColor.color)
                Spacer()
            }
            .padding()
        }
    }
    
    private func getDate(_ day: Day) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let dateString = formatter.string(from: day.id)
        return dateString
    }
}

struct DayListCell_Previews: PreviewProvider {
    static var previews: some View {
        DayListCell(day: Day(id: Date(), text: "Today", fgColor: DayColor()))
    }
}
