//
//  WeekColorView.swift
//  ThemeYourDay
//
//  Created by Christian on 01.09.22.
//
import SwiftUI

struct WeekSettingsView: View {
    
    @EnvironmentObject var modelData: ModelData
    private let weekIndices = [1, 2, 3, 4, 5, 6, 0]
    let weekSettingsType: WeekSettingsType
    
    enum WeekSettingsType {
        case fgcolor
        case bgcolor
        case text
    }
    
    var body: some View {
        Form {
            ForEach(weekIndices, id: \.self) { idx in
                switch weekSettingsType {
                case .fgcolor:
                    DayColorView(dayColor: $modelData.settings.weekdaysFgColor[idx], weekday: weekdaySymbol(dayIndex: idx))
                case .bgcolor:
                    DayColorView(dayColor: $modelData.settings.weekdaysBgColor[idx], weekday: weekdaySymbol(dayIndex: idx))
                case .text:
                    DayTextView(dayText: $modelData.settings.weekdaysText[idx], weekday: weekdaySymbol(dayIndex: idx))
                }
            }
        }
        .navigationBarTitle(title(), displayMode: .inline)
    }
    
    private func weekdaySymbol(dayIndex: Int) -> String {
        Calendar.current.weekdaySymbols[dayIndex]
    }
    
    private func title() -> String {
        switch weekSettingsType {
        case .fgcolor:
            return "Foreground Colors"
        case .bgcolor:
            return "Background Colors"
        case .text:
            return "Texts"
        }
    }
}

struct WeekColorView_Previews: PreviewProvider {
    static var previews: some View {
        WeekSettingsView(weekSettingsType: .bgcolor)
    }
}
