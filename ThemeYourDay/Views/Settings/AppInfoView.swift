import SwiftUI

struct AppInfoView: View {
    var body: some View {
        Form {
            Section("Version \(Bundle.main.appVersion) (\(Bundle.main.buildNumber))") {
                Button {
                } label: {
                    HStack {
                        Image(systemName: "house")
                        Text("Support: www.themeyourday.net")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                NavigationLink {
                    ImprintView()
                } label : {
                    Label("Impressum", systemImage: "scroll")
                        .foregroundStyle(.foreground)
                }
                NavigationLink {
                    TermsOfUseView()
                } label : {
                    Label("Nutzungsbedingungen", systemImage: "checkmark.shield")
                        .foregroundStyle(.foreground)
                }
                NavigationLink {
                    PrivacyView()
                } label : {
                    Label("Datenschutzerklärung", systemImage: "lock")
                        .foregroundStyle(.foreground)
                }
            }
        }
        .navigationTitle("App")
    }
}

extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
    }

    var buildNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "?"
    }
}
