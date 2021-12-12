import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var days: [Day] = MyData.days.sorted {
        $0.id < $1.id
    }
    @Published var selectedDay = MyData.currentDay()
    @Published var selectedIndex = MyData.currentIndex()
    @Published var dayAfter = MyData.dayAfter()
    @Published var dayBefore = MyData.dayBefore()
    @Published var settings = MyData.settings
    
    func writeJSON() {
        writeDayData()
        writeSettingsData()
    }
    
    private func writeDayData() {
        let filename = "DayData.json"
        let file = getDocumentsDirectory().appendingPathComponent(filename)
        
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
        let file = getDocumentsDirectory().appendingPathComponent(filename)
        
        do {
            try JSONEncoder().encode(settings).write(to: file, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func printJson() {
        let filename = "DayData.json"
        let file = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let input = try String(contentsOf: file)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeAllDays() {
        days.removeAll()
        selectDay(Date())
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
        /*let tomorrow = selectedDay.id.dayAfter
        dayBefore = selectedDay
        selectedDay = findDayAfter(tomorrow)
        dayAfter = findDayAfter(selectedDay.id.dayAfter)*/
        selectedIndex += 1
        writeJSON()
    }
    
    func selectDayBefore() {
        /*let yesterday = selectedDay.id.dayBefore
        dayAfter = selectedDay
        selectedDay = findDayBefore(yesterday)
        dayBefore = findDayBefore(selectedDay.id.dayBefore)*/
        selectedIndex -= 1
        writeJSON()
    }
    
    func selectDay(_ date: Date) {
        var found = false
        for day in days {
            if day.id.hasSame(.day, as: date.noon) {
                selectedDay = day
                found = true
                break
            }
        }
        if !found {
            let newDay = Day(id: date, text: "Theme your day", fgColor: DayColor())
            days.append(newDay)
            selectedDay = newDay
            sortDays()
        }
    }
    
    private func findDayAfter(_ date: Date) -> Day {
        for day in days {
            if day.id.hasSame(.day, as: date) {
                return day
            }
        }
        let newDay = Day(id: date, text: "Tomorrow", fgColor: DayColor())
        days.append(newDay)
        sortDays()
        return newDay
    }
    
    private func findDayBefore(_ date: Date) -> Day {
        for day in days {
            if day.id.hasSame(.day, as: date) {
                return day
            }
        }
        let newDay = Day(id: date, text: "Yesterday", fgColor: DayColor())
        days.insert(newDay, at: 0)
        sortDays()
        return newDay
    }
    
    private func sortDays() {
        days.sort {
            $0.id < $1.id
        }
    }
    
    func findDay(_ date: Date) -> Day? {
        //print(date)
        for day in days {
            if day.id.hasSame(.day, as: date.noon) {
                return day
            }
        }
        return nil
    }
}

func getDocumentsDirectory() -> URL {
    // find all possible documents directories for this user
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    // just send back the first one, which ought to be the only one
    return paths[0]
}

func load<T: Codable>(_ filename: String) -> T {
    let data: Data
    let isSettings = filename.contains("Settings")
    let file = getDocumentsDirectory().appendingPathComponent(filename)
    
    print(file.absoluteURL)
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        //fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        data = isSettings ? createSettings()! : createData()!
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        let jsonResultData = isSettings ? createSettings() : createData()
        let decoder = JSONDecoder()
        return try! decoder.decode(T.self, from: jsonResultData!)
        //fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
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
    
    static func loadDays() -> [Day] {
        var loadedDays: [Day] = load("DayData.json")
        let today = Date().noon
        let yesterday = today.dayBefore.noon
        let tomorrow = today.dayAfter.noon
        var foundToday = false
        var foundYesterday = false
        var foundTomorrow = false
        for day in loadedDays {
            if day.id.hasSame(.day, as: today) {
                foundToday = true
            }
            else if day.id.hasSame(.day, as: yesterday) {
                foundYesterday = true
            }
            else if day.id.hasSame(.day, as: tomorrow) {
                foundTomorrow = true
            }
            if foundToday && foundTomorrow && foundYesterday {
                break;
            }
        }
        if (!foundToday) {
            let newDay = Day(id: today, text: "Today", fgColor: DayColor())
            loadedDays.insert(newDay, at: 0)
        }
        if (!foundYesterday) {
            let newDay = Day(id: yesterday, text: "Yesterday", fgColor: DayColor())
            loadedDays.insert(newDay, at: 0)
        }
        if (!foundTomorrow) {
            let newDay = Day(id: tomorrow, text: "Tomorrow", fgColor: DayColor())
            loadedDays.insert(newDay, at: 0)
        }
        loadedDays.sort { $0.id < $1.id }
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
    
    static func dayBefore() -> Day {
        let yesterday = Date().noon.dayBefore.noon
        for day in days {
            if day.id.hasSame(.day, as: yesterday) {
                return day
            }
        }
        let newDay = Day(id: yesterday, text: "Could not find Yesterday!", fgColor: DayColor())
        return newDay
    }
    
    static func dayAfter() -> Day {
        let tomorrow = Date().noon.dayAfter.noon
        for day in days {
            if day.id.hasSame(.day, as: tomorrow) {
                return day
            }
        }
        let newDay = Day(id: tomorrow, text: "Could not find Tomorrow!", fgColor: DayColor())
        return newDay
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


