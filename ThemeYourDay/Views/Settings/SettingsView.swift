import SwiftUI

struct SettingsView: View {
    
    @Environment(ModelData.self) var modelData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("ThemeTemplate")) {
                    NavigationLink(.backgroundColors, destination: WeekSettingsView(weekSettingsType: .bgcolor))
                    NavigationLink(.foregroundColors, destination: WeekSettingsView(weekSettingsType: .fgcolor))
                    NavigationLink(.texts, destination: WeekSettingsView(weekSettingsType: .text))
                }
                NotificationSettingsView()
                Text("App-Version: \(Bundle.main.versionNumberWithBuild ?? "N/A")")
            }
            .navigationBarTitle("Settings", displayMode: .automatic)
            .navigationBarItems(
                trailing: Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(.done)
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
