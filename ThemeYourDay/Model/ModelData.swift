import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var days: [Day] = MyData.days.sorted {
        $0.id < $1.id
    }
    @Published var selectedDay = MyData.currentDay()
    
    func writeJSON() {
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
    
    func removeAllDays() {
        days.removeAll()
        writeJSON()
    }
    
    func saveFgColor(r: Double, g: Double, b: Double, a: Double) {
        let color = DayColor(r: r, g: g, b: b, a: a)
        selectedDay.fgColor = color
    }
    
    func saveBgColor(r: Double, g: Double, b: Double, a: Double) {
        let color = DayColor(r: r, g: g, b: b, a: a)
        selectedDay.bgColor = color
    }
    
    func saveFontname(_ font: String) {
        selectedDay.fontname = font
    }
    
    func selectNextDay() {
        let tomorrow = selectedDay.id.dayAfter
        selectedDay = findDayAfter(tomorrow)
    }
    
    func selectDayBefore() {
        let yesterday = selectedDay.id.dayBefore
        selectedDay = findDayBefore(yesterday)
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
    
    let file = getDocumentsDirectory().appendingPathComponent(filename)
    
    print(file.absoluteURL)
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        //fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        data = createData()!
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        let jsonResultData = createData()
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

struct MyData {
    static var days: [Day] = load("DayData.json")
    
    static func currentDay() -> Day {
        let today = Date().noon
        for day in days {
            if day.id.hasSame(.day, as: today) {
                //print(day.fgColor)
                return day
            }
        }
        return days[0]
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


