import SwiftUI

struct DayList: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            List {
                ForEach(modelData.days) { day in
                    HStack {
                        Text(getDate(day))
                        Text(day.text)
                            .foregroundColor(day.fgColor.color)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        modelData.selectedDay = day
                        self.mode.wrappedValue.dismiss()
                    }
                    .listRowBackground(day.bgColor.color)
                    .padding(0)
                }
            }
        }
    }
    
    private func getDate(_ day: Day) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let dateString = formatter.string(from: day.id)
        return dateString
    }
}

struct DayList_Previews: PreviewProvider {
    static var previews: some View {
        DayList()
    }
}
