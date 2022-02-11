import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    static var loadedDays: [Day] = load("DayData.json")
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), currentDay: Day(id: Date(), text: "Today", fgColor: DayColor()))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), currentDay: Day(id: Date(), text: "Today", fgColor: DayColor()))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, currentDay: getCurrentDay())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func getCurrentDay() -> Day {
        return Provider.currentDay()
    }
    
    static func load<T: Codable>(_ filename: String) -> T {
        let data: Data
        let isSettings = filename.contains("Settings")
        let file = FileManager.sharedContainerURL().appendingPathComponent(filename)
        
        print(file.absoluteURL)
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            data = isSettings ? createSettings()! : createData()!
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            let jsonResultData = isSettings ? createSettings() : createData()
            let decoder = JSONDecoder()
            return try! decoder.decode(T.self, from: jsonResultData!)
        }
    }
    
    static func currentDay() -> Day {
        let today = Date().noon
        for day in loadedDays {
            if day.id.hasSame(.day, as: today) {
                return day
            }
        }
        let newDay = Day(id: today, text: "Could not find Today!", fgColor: DayColor())
        return newDay
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let currentDay: Day
}

struct DayWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        DayWidgetView(day: entry.currentDay)
    }
}

@main
struct DayWidget: Widget {
    let kind: String = "DayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Day Widget")
        .description("This is an example widget.")
    }
}

struct DayWidget_Previews: PreviewProvider {
    static var previews: some View {
        DayWidgetEntryView(entry: SimpleEntry(date: Date(), currentDay: Day(id: Date(), text: "Today", fgColor: DayColor())))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
