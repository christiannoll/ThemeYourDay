//
//  NotificationSettingsView.swift
//  ThemeYourDay
//
//  Created by Christian on 05.02.23.
//

import SwiftUI
import SwiftData

struct NotificationSettingsView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    @Query() var settings: [Settings]
    
    var enabledBinding: Binding<Bool> {
        return Binding(get: {
            return settings.first?.notificationSettings.notificationEnabledByUser ?? false
        }, set: { newValue in
            settings.first?.notificationSettings.notificationEnabledByUser = newValue
        })
    }
    
    var remindAtBinding: Binding<Date> {
        return Binding(get: {
            return settings.first?.notificationSettings.remindAt ?? Date()
        }, set: { newValue in
            settings.first?.notificationSettings.remindAt = newValue
        })
    }
    
    var body: some View {
        Section(header: Text(.notification)) {
            HStack {
                Text(.notificationStatus)
                Spacer()
                Text(viewModel.currentStatus)
                    .font(.headline)
            }
            if viewModel.isAskPermissionButtonVisible {
                Button {
                    viewModel.askPermissions()
                } label: {
                    Text(.askUserPermissions)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            if viewModel.isOpenSettingsButtonVisible {
                Button {
                    viewModel.openSettings()
                } label: {
                    Text(.openSystemSettings)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        Section {
            if let mySettings = settings.first {
                Toggle(.notificationEnabled,
                       isOn: enabledBinding)
                .disabled(!viewModel.isEnableNotificationToggleEnabled)
                .onChange(of: mySettings.notificationSettings.notificationEnabledByUser) {
                    if !mySettings.notificationSettings.notificationEnabledByUser {
                        viewModel.cancelNotificationRequest()
                    }
                }
                
                if mySettings.notificationSettings.notificationEnabledByUser {
                    DatePicker(
                        .remindAt,
                        selection: remindAtBinding,
                        displayedComponents: .hourAndMinute
                    )
                    .disabled(!viewModel.isEnableNotificationToggleEnabled)
                    .onChange(of: mySettings.notificationSettings.remindAt) {
                        viewModel.registerNotificationRequest(settings: mySettings)
                    }
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
