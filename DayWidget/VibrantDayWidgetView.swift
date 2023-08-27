//
//  VibrantDayWidgetView.swift
//  ThemeYourDay
//
//  Created by Christian on 15.01.23.
//

import SwiftUI

struct VibrantDayWidgetView: View {
    let day: MyDay
    
    var body: some View {
        Text(day.text)
            .font(.headline)
            .widgetAccentable()
    }
}

struct VibrantDayWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        VibrantDayWidgetView(day: MyDay(id: Date(), text: "Theme your day", fgColor: DayColor()))
    }
}
