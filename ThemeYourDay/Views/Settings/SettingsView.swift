import SwiftUI

struct SettingsView: View {
    
    @Environment(ModelData.self) var modelData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("ThemeTemplate")) {
                    NavigationLink("BackgroundColors", destination: WeekSettingsView(weekSettingsType: .bgcolor))
                    NavigationLink("ForegroundColors", destination: WeekSettingsView(weekSettingsType: .fgcolor))
                    NavigationLink("Texts", destination: WeekSettingsView(weekSettingsType: .text))
                }
                Section("Design") {
                    AppearancePicker()
                }
                Section {
                    NavigationLink("Notification", destination: NotificationSettingsView())
                }
                Label("App-Version: \(Bundle.main.versionNumberWithBuild ?? "N/A")", systemImage: "info.circle")
            }
            .navigationBarTitle("Settings", displayMode: .automatic)
            .navigationBarItems(
                trailing: Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done")
                }
            )
        }
    }
}

#Preview {
    SettingsView()
}
