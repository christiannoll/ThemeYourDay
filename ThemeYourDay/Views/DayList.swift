import SwiftUI

struct DayList: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            List {
                ForEach(modelData.days.reversed()) { day in
                    DayListCell(day: day)
                        .onTapGesture {
                            modelData.selectedDay = day
                            self.mode.wrappedValue.dismiss()
                        }
                        .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Days")
        .navigationBarItems(trailing: Button(action: { removeAllDays() }) {
            Image(systemName: "trash")
        }.padding())
    }
    
    private func removeAllDays() {
        modelData.removeAllDays()
    }
}

struct DayList_Previews: PreviewProvider {
    static var previews: some View {
        DayList()
    }
}
