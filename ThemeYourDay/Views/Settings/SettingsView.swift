import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var modelData: ModelData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(.themeTemplate)) {
                    NavigationLink(.backgroundColors, destination: WeekSettingsView(weekSettingsType: .bgcolor))
                    NavigationLink(.foregroundColors, destination: WeekSettingsView(weekSettingsType: .fgcolor))
                    NavigationLink("Texts", destination: WeekSettingsView(weekSettingsType: .text))
                }
                NotificationSettingsView()
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
