import SwiftUI

struct AppearancePicker: View {
    @AppStorage("appearance") private var appearance: Appearance = .system

    var body: some View {
        Picker("Appearance", selection: $appearance) {
            ForEach(Appearance.allCases, id: \.self) { option in
                Text(String(localized: String.LocalizationValue(option.label))).tag(option)
            }
        }
        .pickerStyle(.segmented)
    }
}
