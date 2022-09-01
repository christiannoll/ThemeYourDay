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
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(weekIndices, id: \.self) { idx in
                    DayColorView(dayColor: $modelData.settings.weekdaysBgColor[idx], weekday: weekdaySymbol(dayIndex: idx))
                }
            }
            .navigationBarTitle("Background Colors", displayMode: .inline)
        }
    }
    
    private func weekdaySymbol(dayIndex: Int) -> String {
        Calendar.current.weekdaySymbols[dayIndex]
    }
}

struct WeekColorView_Previews: PreviewProvider {
    static var previews: some View {
        WeekColorView()
    }
}
