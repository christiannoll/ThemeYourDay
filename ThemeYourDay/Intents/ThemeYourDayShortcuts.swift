//
//  ThemeYourDayShortcuts.swift
//  ThemeYourDay
//
//  Created by Christian on 03.10.23.
//

import AppIntents

struct ThemeYourDayShortcuts: AppShortcutsProvider {
 
    static var appShortcuts: [AppShortcut] {

        AppShortcut(
          intent: ThemeTodayIntent(),
          phrases: [
            "Theme today",
            "\(.applicationName)"
          ],
          shortTitle: "Theme today",
          systemImageName: "calendar"
        )
      }
}
