import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var days: [Day] = MyData.days
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
    
    func saveFgColor(r: Double, g: Double, b: Double, a: Double) {
        let color = DayColor(r: r, g: g, b: b, a: a)
        selectedDay.fgColor = color
    }
    
    func selectNextDay() {
        let tomorrow = selectedDay.id.dayAfter
        selectedDay = findDayAfter(tomorrow)
    }
    
    func selectDayBefore() {
        let yesterday = selectedDay.id.dayBefore
        selectedDay = findDayBefore(yesterday)
    }
    
    private func findDayAfter(_ date: Date) -> Day {
        for day in days {
            if day.id.hasSame(.day, as: date) {
                return day
            }
        }
        let newDay = Day(id: date, text: "Tomorrow", fgColor: DayColor())
        days.append(newDay)
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
        return newDay
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
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        let days = [Day(id: Date(), text: "Today", fgColor: DayColor())]
        let jsonEncoder = JSONEncoder()
        let jsonResultData = try? jsonEncoder.encode(days)
        let decoder = JSONDecoder()
        return try! decoder.decode(T.self, from: jsonResultData!)
        //fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
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
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }

    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }

    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
}


