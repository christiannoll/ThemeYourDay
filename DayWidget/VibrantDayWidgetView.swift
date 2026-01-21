import SwiftUI

struct VibrantDayWidgetView: View {
    let day: Day
    
    var body: some View {
        Text(day.text)
            .font(.headline)
            .widgetAccentable()
            .containerBackground(.clear, for: .widget)
    }
}

struct VibrantDayWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        VibrantDayWidgetView(day: Day(id: Date(), text: "Theme your day", fgColor: DayColor()))
    }
}
