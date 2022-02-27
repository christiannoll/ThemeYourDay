import Foundation
import WidgetKit

final class ModelData: ObservableObject {
    @Published var days: [Day] = MyData.days.sorted {
        $0.id < $1.id
    }
    @Published var selectedDay = MyData.currentDay()
    @Published var selectedIndex = MyData.currentIndex()
    @Published var settings = MyData.settings
    
    func writeJSON() {
        writeDayData()
        writeSettingsData()
        informWidget()
    }
    
    private func informWidget() {
        WidgetCenter.shared.reloadTimelines(ofKind: "de.vnzn.ThemeYourDay.DayWidget")
    }
    
    private func writeDayData() {
        let filename = "DayData.json"
        let file = FileManager.sharedContainerURL().appendingPathComponent(filename)
        
        for index in 0..<days.count {
            if days[index].id == selectedDay.id {
                days[index] = selectedDay
            }
        }
        
        //print(days)
        
        do {
            try JSONEncoder().encode(days).write(to: file, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func writeSettingsData() {
        let filename = "SettingsData.json"
        let file = FileManager.sharedContainerURL().appendingPathComponent(filename)
        
        do {
            try JSONEncoder().encode(settings).write(to: file, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func printJson() {
        let filename = "DayData.json"
        let file = FileManager.sharedContainerURL().appendingPathComponent(filename)
        do {
            let input = try String(contentsOf: file)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeAllDays() {
        for index in 0..<days.count {
            let newDay = Day(id: days[index].id, text: "New Day", fgColor: DayColor())
            days[index] = newDay
        }
        writeJSON()
    }
    
    func saveFgColor(r: Double, g: Double, b: Double, a: Double) {
        let color = DayColor(r: r, g: g, b: b, a: a)
        selectedDay.fgColor = color

        if !settings.fgColors.contains(color) {
            settings.fgColors.insert(color, at: 0)
            if settings.fgColors.count > 5 {
                settings.fgColors = settings.fgColors.dropLast()
            }
        }
    }
    
    func saveBgColor(r: Double, g: Double, b: Double, a: Double) {
        let color = DayColor(r: r, g: g, b: b, a: a)
        selectedDay.bgColor = color
        
        if !settings.bgColors.contains(color) {
            settings.bgColors.insert(color, at: 0)
            if settings.bgColors.count > 5 {
                settings.bgColors = settings.bgColors.dropLast()
            }
        }
    }
    
    func saveFontname(_ font: String) {
        selectedDay.fontname = font
    }
    
    func selectNextDay() {
        selectedIndex += 1
        selectedDay = days[selectedIndex]
        writeJSON()
    }
    
    func selectDayBefore() {
        selectedIndex -= 1
        selectedDay = days[selectedIndex]
        writeJSON()
    }
    
    func selectDay(_ date: Date) {
        var index = -1
        for day in days {
            index += 1
            if day.id.hasSame(.day, as: date.noon) {
                selectedIndex = index
                selectedDay = day
                break
            }
        }
    }
    
    func selectDay(_ day: Day) {
        let index = getSelectedIndex(day)
        selectedIndex = index
        selectedDay = day
    }
    
    private func getSelectedIndex(_ searchedDay: Day) -> Int {
        var index = -1
        for day in days {
            index += 1
            if day.id.hasSame(.day, as: searchedDay.id) {
                break
            }
        }
        return index
    }
    
    func findDay(_ date: Date) -> Day? {
        //print(date)
        if let index = MyData.indexCache[date.noon] {
            return days[index]
        }
        return nil
    }
}

func load<T: Codable>(_ filename: String) -> T {
    let data: Data
    let isSettings = filename.contains("Settings")
    let file = FileManager.sharedContainerURL().appendingPathComponent(filename)
    
    //print(file.absoluteURL)
    
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

func createData() -> Data? {
    let days = [Day(id: Date(), text: "Today", fgColor: DayColor())]
    let jsonEncoder = JSONEncoder()
    let jsonResultData = try? jsonEncoder.encode(days)
    return jsonResultData
}

func createSettings() -> Data? {
    let settings = Settings(fgColors: [DayColor()], bgColors: [DayColor()])
    let jsonEncoder = JSONEncoder()
    let jsonResultData = try? jsonEncoder.encode(settings)
    return jsonResultData
}


struct MyData {
    static var days: [Day] = loadDays()
    static var settings: Settings = loadSettings()
    static var indexCache : [Date:Int] = [:]
    
    static func loadDays() -> [Day] {
        var loadedDays: [Day] = load("DayData.json")
    
        let endDate = Date().getNextMonth()?.noon
        var day = Date().getPreviousMonth()?.noon
        
        while day != endDate {
            var loaded = false
            for loadedDay in loadedDays {
                if loadedDay.id.hasSame(.day, as: day!) {
                    loaded = true
                    break
                }
            }
            
            if !loaded {
                let newDay = Day(id: day!, text: "New Day", fgColor: DayColor())
                loadedDays.insert(newDay, at: 0)
            }
            
            day = day!.dayAfter.noon
        }
        
        loadedDays.sort { $0.id < $1.id }
        
        for (index, day) in loadedDays.enumerated() {
            indexCache[day.id] = index
        }
        
        return loadedDays
    }
    
    static func loadSettings() -> Settings {
        let loadedSettings: Settings = load("SettingsData.json")
        return loadedSettings
    }
    
    static func currentDay() -> Day {
        let today = Date().noon
        for day in days {
            if day.id.hasSame(.day, as: today) {
                return day
            }
        }
        let newDay = Day(id: today, text: "Could not find Today!", fgColor: DayColor())
        return newDay
    }
    
    static func currentIndex() -> Int {
        let today = Date().noon
        var index = -1
        for day in days {
            index += 1
            if day.id.hasSame(.day, as: today) {
                break
            }
        }
        return index
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self.noon, to: date).value(for: component)
    }

    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self.noon)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }

    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        fullDistance(from: date.noon, resultIn: component) == 0
    }
}

extension Date {
    func getNextMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)
    }

    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
}

extension FileManager {
  static func sharedContainerURL() -> URL {
    return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: "group.de.vnzn.ThemeYourDay"
    )!
  }
}



