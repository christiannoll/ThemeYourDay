import SwiftUI

struct DayList: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var showDeleteAlert = false
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(modelData.days.reversed()) { day in
                    DayListCell(day: day)
                        .onTapGesture {
                            modelData.selectedDay = day
                            self.mode.wrappedValue.dismiss()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                }
            }
        }
        .navigationBarTitle("Days", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: { showDeleteAlert.toggle() }) {
            Image(systemName: "trash")
        }.padding())
        .alert(isPresented: $showDeleteAlert) {
            Alert(title: Text("Remove All Themes?"), message: Text("This will remove all themes and can't be undone."), primaryButton: .destructive(Text("Remove"), action: { removeAllDays() }), secondaryButton: .cancel(Text("Cancel")))
        }
    }
    
    private func removeAllDays() {
        modelData.removeAllDays()
    }
}

struct DayList_Previews: PreviewProvider {
    static var previews: some View {
        DayList()
            .environmentObject(ModelData())
    }
}
