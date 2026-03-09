import SwiftUI

struct ImprintView: View {

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("v.n.z.n (Christian Noll)\nBautzner Straße 7b\n24837 Schleswig")
                    .padding()
                Spacer()
            }
            Text("Email: webmaster (at) vnzn (punkt) de\nGitHub: [christiannoll](https://github.com/christiannoll/vnzn)\nMastodon: [@vnzn@mas.to](https://mas.to/@vnzn)")
                .padding()
            Spacer()
        }
        .navigationTitle("Impressum")
    }
}
