import SwiftUI

struct ImprintView: View {

    var body: some View {
        Form {
            Section("Impressum") {
                Text("v.n.z.n (Christian Noll)\nBautzner Straße 7b\n24837 Schleswig")
                Text("Email: webmaster (at) vnzn (punkt) de\nGitHub: [christiannoll](https://github.com/christiannoll/vnzn)\nMastodon: [@vnzn@mas.to](https://mas.to/@vnzn)")
            }
        }
    }
}
