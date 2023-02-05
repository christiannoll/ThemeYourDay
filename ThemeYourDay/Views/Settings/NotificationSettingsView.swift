//
//  NotificationSettingsView.swift
//  ThemeYourDay
//
//  Created by Christian on 05.02.23.
//

import SwiftUI

struct NotificationSettingsView: View {
    
    @EnvironmentObject var modelData: ModelData
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        Section(header: Text("Notification")) {
            Toggle("Notification Enabled:",
                   isOn: $modelData.settings.notificationSettings.notificationEnabledByUser)
            .disabled(viewModel.isEnableNotificationToggleEnabled)
         
            if modelData.settings.notificationSettings.notificationEnabledByUser {
                DatePicker(
                    "Remind at:",
                    selection: $modelData.settings.notificationSettings.remindAt,
                    displayedComponents: .hourAndMinute
                )
                .disabled(viewModel.isEnableNotificationToggleEnabled)
            }
        }
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}
