import SwiftUI
import SwiftData

fileprivate extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }

    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }

    static var Year: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }

        return dates
    }
}

struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    @Environment(ModelData.self) var modelData
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Query(sort: [SortDescriptor(\Day.id)]) var myDays: [Day]

    let week: Date
    let content: (Date) -> DateView

    init(week: Date, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.week = week
        self.content = content
    }

    private var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
            else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        HStack {
            ForEach(days, id: \.self) { date in
                HStack {
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                        self.content(date)
                    } else {
                        self.content(date).hidden()
                    }
                }
                .onTapGesture {
                    modelData.selectDay(date, days: myDays)
                    self.mode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    @Environment(ModelData.self) var modelData

    let month: Date
    let showHeader: Bool
    let content: (Date) -> DateView

    init(
        month: Date,
        showHeader: Bool = true,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.month = month
        self.content = content
        self.showHeader = showHeader
    }

    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
            else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }

    private var header: some View {
        let formatter = DateFormatter.month
        return Text(formatter.string(from: month))
            .font(.title)
            .padding()
    }

    var body: some View {
        VStack {
            if showHeader {
                header
            }

            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, content: self.content)
            }
        }
    }
}

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    @Environment(ModelData.self) var modelData

    let interval: DateInterval
    let nextMonth: () -> Void
    let previousMoth: () -> Void
    let content: (Date) -> DateView

    init(interval: DateInterval,
         nextMonth: @escaping () -> Void,
         previousMoth: @escaping () -> Void,
         @ViewBuilder content: @escaping (Date) -> DateView) {
        self.interval = interval
        self.nextMonth = nextMonth
        self.previousMoth = previousMoth
        self.content = content
    }

    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ScrollViewReader { value in
                LazyVStack {
                    ForEach(months, id: \.self) { month in
                        MonthView(month: month, content: self.content)
                            .id(calendar.component(.month, from: month))
                    }
                }
            }
        }
        .toolbar {
            HStack {
                Button(action: { previousMoth() }) {
                    Image(systemName: "chevron.left")
                }.padding(.horizontal, 8)
                Text(months[1], format: .dateTime.month())
                Button(action: { nextMonth() }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.trailing)
        }
        .navigationTitle(DateFormatter.Year.string(from: months.first ?? Date()))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(interval: .init(), nextMonth: {}, previousMoth: {}) { _ in
            Text("30")
                .padding(8)
                .background(Color.blue)
                .cornerRadius(8)
        }
        .environment(ModelData())
    }
}

