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
                            .foregroundStyle(.foreground)
                    }
                    NavigationLink {
                        NotificationSettingsView()
                    } label : {
                        Label("Notification", systemImage: "bell.badge")
                            .foregroundStyle(.foreground)
                    }
                    NavigationLink {
                        AppInfoView()
                    } label : {
                        Label("Über die App", systemImage: "info.circle")
                            .foregroundStyle(.foreground)
                    }
                }
                Section("Design") {
                    AppearancePicker()
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", systemImage: "xmark") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
