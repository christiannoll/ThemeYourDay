//
//  WeekColorView.swift
//  ThemeYourDay
//
//  Created by Christian on 01.09.22.
//
import SwiftUI

struct WeekColorView: View {
    
    @EnvironmentObject var modelData: ModelData
    private let weekIndices = [1, 2, 3, 4, 5, 6, 0]
    let colorKind: ColorKind
    
    enum ColorKind {
        case foreground
        case background
    }
    
    var body: some View {
        Form {
            ForEach(weekIndices, id: \.self) { idx in
                switch colorKind {
                case .foreground:
                    DayColorView(dayColor: $modelData.settings.weekdaysFgColor[idx], weekday: weekdaySymbol(dayIndex: idx))
                case .background:
                    DayColorView(dayColor: $modelData.settings.weekdaysBgColor[idx], weekday: weekdaySymbol(dayIndex: idx))
                }
            }
        }
        .navigationBarTitle(title(), displayMode: .inline)
    }
    
    private func weekdaySymbol(dayIndex: Int) -> String {
        Calendar.current.weekdaySymbols[dayIndex]
    }
    
    private func title() -> String {
        switch colorKind {
        case .foreground:
            return "Foreground Colors"
        case .background:
            return "Background Colors"
        }
    }
}

struct WeekColorView_Previews: PreviewProvider {
    static var previews: some View {
        WeekColorView(colorKind: .background)
    }
}
