import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var modelData: ModelData
    @Environment(\.presentationMode) var presentationMode
    
    private let weekIndices = [1, 2, 3, 4, 5, 6, 0]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Card template")) {
                    Toggle(isOn: .constant(true),
                           label: { Text("Use default") }
                    )
                    ForEach(weekIndices, id: \.self) { idx in
                        DayColorView(dayColor: $modelData.settings.weekdaysBgColor[idx], weekday: weekdaySymbol(dayIndex: idx))
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .automatic)
            .navigationBarItems(
                trailing: Button {
                    modelData.writeSettings()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done")
                }
            )
        }
    }
    
    private func weekdaySymbol(dayIndex: Int) -> String {
        Calendar.current.weekdaySymbols[dayIndex]
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
