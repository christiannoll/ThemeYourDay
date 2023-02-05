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
            HStack {
                Text("Notification Status:")
                Text(viewModel.currentStatus)
                    .font(.headline)
            }
            if viewModel.isAskPermissionButtonVisible {
                Button {
                    viewModel.askPermissions()
                } label: {
                    Text("Ask user permissions")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            if viewModel.isOpenSettingsButtonVisible {
                Button {
                    viewModel.openSettings()
                } label: {
                    Text("Open system settings")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        Section {
            Toggle("Notification Enabled:",
                   isOn: $modelData.settings.notificationSettings.notificationEnabledByUser)
            .disabled(!viewModel.isEnableNotificationToggleEnabled)
            .onChange(of: modelData.settings.notificationSettings.notificationEnabledByUser) { enabled in
                if !enabled {
                    viewModel.cancelNotificationRequest()
                }
            }
         
            if modelData.settings.notificationSettings.notificationEnabledByUser {
                DatePicker(
                    "Remind at:",
                    selection: $modelData.settings.notificationSettings.remindAt,
                    displayedComponents: .hourAndMinute
                )
                .disabled(!viewModel.isEnableNotificationToggleEnabled)
                .onChange(of: modelData.settings.notificationSettings.remindAt) { _ in
                    viewModel.registerNotificationRequest(modelData: modelData)
                }
            }
        }
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}
