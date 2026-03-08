import SwiftUI

struct SettingsView: View {
    
    @Environment(ModelData.self) var modelData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            Form {
                Section("App") {
                    NavigationLink {
                        ThemeSettingsView()
                    } label : {
                        Label("ThemeTemplate", systemImage: "text.square.filled")
                    }
                    NavigationLink {
                        NotificationSettingsView()
                    } label : {
                        Label("Notification", systemImage: "bell.badge")
                    }
                    NavigationLink {
                        AppInfoView()
                    } label : {
                        Label("Über die App", systemImage: "info.circle")
                    }
                }
                Section("Design") {
                    AppearancePicker()
                }
            }
            .navigationTitle("Settings")
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
