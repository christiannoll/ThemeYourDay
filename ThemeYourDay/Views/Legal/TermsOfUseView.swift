import SwiftUI

struct TermsOfUseView: View {

    var body: some View {
        VStack(alignment: .leading) {
            Text("Die Nutzung der App ThemeYourDay unterliegt Apples Standard-EULA für Apps. Die in ThemeYourDay bereitgestellten Trinkgelder schalten keine zusätzlichen Inhalte in der App frei.")
                .padding()
            Spacer()
        }
        .navigationTitle("Nutzungsbedingungen")
    }
}
