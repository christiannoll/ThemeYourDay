import SwiftUI

struct AppInfoView: View {
    var body: some View {
        Form {
            Section("Version: \(AppVersionProvider.appVersion())") {
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

enum AppVersionProvider {
    static func appVersion(in bundle: Bundle = .main) -> String {
        guard let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            fatalError("CFBundleShortVersionString should not be missing from info dictionary")
        }
        return version
    }
}
