import WidgetKit
import SwiftUI
import SwiftData

struct Provider: @MainActor TimelineProvider {

    var modelContainer: ModelContainer?

    init() {
        modelContainer = try? ModelContainer(for: Day.self, Settings.self, NotificationSettings.self)
    }

    func placeholder(in context: Context) -> SimpleEntry {
        createSimpleEntry()
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = createSimpleEntry()
        completion(entry)
    }

    @MainActor 
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, currentDay: today())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    @MainActor
    private func today() -> Day {
        let today = Date().noon
        let dayFetchDescriptor = FetchDescriptor<Day>()
        guard let days = try? modelContainer?.mainContext.fetch(dayFetchDescriptor) else {
            return defaultDay(today)
        }
        
        for day in days {
            if day.id.hasSame(.day, as: today) {
                return day
            }
        }
        return defaultDay(today)
    }
    
    private func createSimpleEntry() -> SimpleEntry {
        SimpleEntry(date: Date(), currentDay: Day(id: Date(), text: "Theme your day", fgColor: DayColor()))
    }
    
    private func defaultDay(_ today: Date) -> Day {
        Day(id: today, text: "Could not find Today!", fgColor: DayColor())
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let currentDay: Day
}

struct DayWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetRenderingMode) private var renderingMode

    var body: some View {
        switch renderingMode {
        case .vibrant:
            VibrantDayWidgetView(day: entry.currentDay)
        case .fullColor:
            DayWidgetView(day: entry.currentDay)
        default:
            EmptyView()
        }
    }
}

@main
struct DayWidget: Widget {
    let kind: String = "de.vnzn.ThemeYourDay.DayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Day Widget")
        .description("This is a ThemeYourDay widget.")
        .supportedFamilies(
            [
                .systemSmall,
                .systemMedium,
                .systemLarge,
                .systemExtraLarge,
                //.accessoryInline,
                //.accessoryCircular,
                .accessoryRectangular
            ]
        )
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    DayWidget()
} timeline: {
    SimpleEntry(date: .now, currentDay: Day(id: Date(), text: "Theme your day", fgColor: DayColor()))
    SimpleEntry(date: .now, currentDay: Day(id: Date(), text: "Theme your day", fgColor: DayColor()))
}
