import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var modelData: ModelData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Theme template")) {
                    NavigationLink("Background Colors", destination: WeekSettingsView(weekSettingsType: .bgcolor))
                    NavigationLink("Foreground Colors", destination: WeekSettingsView(weekSettingsType: .fgcolor))
                    NavigationLink("Texts", destination: WeekSettingsView(weekSettingsType: .text))
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
