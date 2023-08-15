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
                    NavigationLink(.texts, destination: WeekSettingsView(weekSettingsType: .text))
                }
                NotificationSettingsView()
            }
            .navigationBarTitle(.settings, displayMode: .automatic)
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
