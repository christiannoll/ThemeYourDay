//
//  WeekColorView.swift
//  ThemeYourDay
//
//  Created by Christian on 01.09.22.
//
import SwiftUI
import SwiftData

struct WeekSettingsView: View {
    
    @Query() var settings: [Settings]
    private let weekIndices = [1, 2, 3, 4, 5, 6, 0]
    let weekSettingsType: WeekSettingsType
    @Environment(ModelData.self) var modelData
    @Environment(\.modelContext) private var context

    enum WeekSettingsType {
        case fgcolor
        case bgcolor
        case text
    }
    
    var body: some View {
        Form {
            if let mySettings = settings.first {
                ForEach(weekIndices, id: \.self) { idx in
                    switch weekSettingsType {
                    case .fgcolor:
                        DayColorView(dayColor: mySettings.weekdaysFgColor[idx], weekday: weekdaySymbol(dayIndex: idx), index: idx, save: saveFgColor)
                    case .bgcolor:
                        DayColorView(dayColor: mySettings.weekdaysBgColor[idx], weekday: weekdaySymbol(dayIndex: idx), index: idx, save: saveBgColor)
                    case .text:
                        DayTextView(dayText: mySettings.weekdaysText[idx], weekday: weekdaySymbol(dayIndex: idx), index: idx, save: saveWeekdayText)
                    }
                }
            }
        }
        .navigationBarTitle(title(), displayMode: .inline)
    }
    
    private func weekdaySymbol(dayIndex: Int) -> String {
        Calendar.current.weekdaySymbols[dayIndex]
    }
    
    private func saveFgColor(dayColor: DayColor, index: Int) {
        if let mySettings = settings.first {
            mySettings.weekdaysFgColor[index] = dayColor
            modelData.save(context)
        }
    }
    
    private func saveBgColor(dayColor: DayColor, index: Int) {
        if let mySettings = settings.first {
            mySettings.weekdaysBgColor[index] = dayColor
            modelData.save(context)
        }
    }
    
    private func saveWeekdayText(dayText: String, index: Int) {
        if let mySettings = settings.first {
            mySettings.weekdaysText[index] = dayText
        }
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
