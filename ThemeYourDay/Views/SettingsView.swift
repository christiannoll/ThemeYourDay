import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var modelData: ModelData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Card template")) {
                    Toggle(isOn: .constant(true),
                           label: { Text("Use default") }
                    )
                    NavigationLink("Background Colors", destination: WeekColorView(colorKind: .background))
                    NavigationLink("Foreground Colors", destination: WeekColorView(colorKind: .foreground))
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
