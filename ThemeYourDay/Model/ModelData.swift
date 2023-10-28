import Foundation
import WidgetKit
import SwiftData

@Observable
final class ModelData {
    var selectedIndex = -1
    var stickers = loadStickers()
    var snippets = loadSnippets()
    var selectedDay: Day? = nil
    
    static var indexCache : [Date:Int] = [:]
    
    func saveImageOfSelectedDay(imageData: Data) {
        let file = getImageFilenameOfSelectedDay()
        
        do {
            try imageData.write(to: file, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func savePngImageOfSelectedDay(data: Data) {
        let file = getPngImageFilenameOfSelectedDay()
        
        do {
            try data.write(to: file, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadImageOfSelectedDay() -> Data? {
        let file = getImageFilenameOfSelectedDay()
        
        do {
            let imageData = try Data(contentsOf: file)
            return imageData
        } catch {}
        return nil
    }
    
    func deleteImageOfSelectedDay() {
        let file = getImageFilenameOfSelectedDay()
        let pngFile = getPngImageFilenameOfSelectedDay()
        
        do {
            try FileManager.default.removeItem(at: file)
            try FileManager.default.removeItem(at: pngFile)
        } catch {}
    }
    
    func informWidget() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func removeAllDays(_ days: [Day], settings: Settings) {
        for index in 0..<days.count {
            days[index].sticker = Sticker()
            days[index].bgColor = Day.defaultBgColor
            days[index].fgColor = DayColor()
            days[index].text = defaultWeekdayText(days[index].id, settings: settings)
        }
        informWidget()
    }
    
    func saveFgColor(r: Double, g: Double, b: Double, a: Double, settings: Settings?) {
        let color = DayColor(r: r, g: g, b: b, a: a)
        if let selectedDay {
            if selectedDay.fgColor != color {
                selectedDay.fgColor = color
                
                if let settings, !settings.fgColors.contains(color) {
                    settings.fgColors.insert(color, at: 0)
                    if settings.fgColors.count > 5 {
                        settings.fgColors = settings.fgColors.dropLast()
                    }
                }
            }
        }
    }
    
    func saveBgColor(r: Double, g: Double, b: Double, a: Double, settings: Settings?) {
        let color = DayColor(r: r, g: g, b: b, a: a)
        if let selectedDay {
            if selectedDay.bgColor != color {
                selectedDay.bgColor = color
                
                if let settings, !settings.bgColors.contains(color) {
                    settings.bgColors.insert(color, at: 0)
                    if settings.bgColors.count > 5 {
                        settings.bgColors = settings.bgColors.dropLast()
                    }
                }
            }
        }
    }
    
    func selectDay(_ date: Date, days: [Day]) {
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
    
    func selectDay(_ _day: Day, days: [Day]) {
        var index = -1
        for day in days {
            index += 1
            if day.id.hasSame(.day, as: _day.id.noon) {
                selectedIndex = index
                selectedDay = day
                break
            }
        }
    }
    
    func getToday(_ days: [Day]) -> Day? {
        let today = Date().noon
        var toDay: Day? = nil
        for day in days {
            if day.id.noon == today {
                toDay = day
                break
            }
        }
        return toDay
    }
    
    func applyToToday(_ days: [Day]) {
        if let today = getToday(days), days.count > selectedIndex {
            let day = days[selectedIndex]
            today.text = day.text
            today.fgColor = day.fgColor
            today.bgColor = day.bgColor
            today.sticker = day.sticker
            today.textAlignment = day.textAlignment
            today.textStyle = day.textStyle
            today.fontname = day.fontname
            selectDay(today, days: days)
        }
    }
    
    func exportAsCsvFile(_ days: [Day], settings: Settings) {
        var csvString = "date,text\n"
        for day in days {
            if day.text != defaultWeekdayText(day.id, settings: settings) {
                let dataString = "\(day.id.description),\(day.text)\n"
                csvString = csvString.appending(dataString)
            }
        }
        writeCsvFile(csvString)
    }
    
    func isToday(day: Day?) -> Bool {
        guard let day = day else {
            return false
        }
        return day.id == Date().noon
    }
    
    func getSharedThemeFileName() -> String {
        guard let selectedDay else {
            return "Error"
        }
        let dateStr = selectedDay.id.formatted(.iso8601.day().month().year())
        let fileName = dateStr + "-Day.png"
        return fileName
    }
    
    func insertNewDays(context: ModelContext, days: [Day], settings: Settings, monthOffset: Int) {
        var nextMonth = Date().noon.getNextMonth()?.noon
        for _ in 1..<monthOffset {
            nextMonth = nextMonth?.getNextMonth()?.noon
        }
        
        if let lastDay = days.last {
            if lastDay.id >= nextMonth! {
                return
            }
            
            let newEndDate = lastDay.id.getNextMonth()?.noon
            var endDate = lastDay.id.dayAfter.noon
            var index = days.count
            
            while endDate != newEndDate {
                let newDay = Day(id: endDate, text: settings.weekdaysText[endDate.weekday - 1],
                                 fgColor: settings.weekdaysFgColor[endDate.weekday - 1],
                                 bgColor: settings.weekdaysBgColor[endDate.weekday - 1])
                context.insert(newDay)
                Self.indexCache[newDay.id.noon] = index
                endDate = newDay.id.dayAfter.noon
                index += 1
            }
        }
    }
    
    private func defaultWeekdayText(_ date: Date, settings: Settings) -> String {
        settings.weekdaysText[date.weekday - 1]
    }
    
    private func writeCsvFile(_ csvString: String) {
        let filename = "ExortedDays.csv"
        let file = FileManager.sharedContainerURL().appendingPathComponent(filename)
        
        do {
            try csvString.write(to: file, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getImageFilenameOfSelectedDay() -> URL {
        guard let selectedDay else {
            return FileManager.sharedContainerURL().appendingPathComponent("Error")
        }
        let filename = selectedDay.id.formatted(.iso8601) + ".img"
        let file = FileManager.sharedContainerURL().appendingPathComponent(filename)
        return file
    }
    
    private func getPngImageFilenameOfSelectedDay() -> URL {
        guard let selectedDay else {
            return FileManager.sharedContainerURL().appendingPathComponent("Error")
        }
        let filename = selectedDay.id.formatted(.iso8601) + ".png"
        let file = FileManager.sharedContainerURL().appendingPathComponent(filename)
        return file
    }
    
    func getPngImageFilename(date: Date) -> URL {
        return getPngImageFileUrl(date: date)
    }
    
    private static func loadStickers() -> [Sticker] {
        let stickers: [Sticker] = load("StickerData", type: .bundle, createData: createStickers)
        return stickers
    }
    
    private static func loadSnippets() -> [Snippet] {
        let snippets: [Snippet] = load("SnippetData", type: .bundle, createData: createSnipppets)
        return snippets
    }
}

func getPngImageFileUrl(date: Date) -> URL {
    let filename = date.formatted(.iso8601) + ".png"
    let file = FileManager.sharedContainerURL().appendingPathComponent(filename)
    return file
}

enum StorageType {
    case bundle
    case container
}

func load<T: Codable>(_ filename: String, type: StorageType, createData: () -> Data?) -> T {
    let data: Data
    let file = type == .bundle ? Bundle.main.url(forResource: filename, withExtension: "json") : FileManager.sharedContainerURL().appendingPathComponent(filename)
    
    do {
        data = try Data(contentsOf: file!)
    } catch {
        data = createData()!
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        let jsonResultData = createData()!
        let decoder = JSONDecoder()
        return try! decoder.decode(T.self, from: jsonResultData)
    }
}

func createStickers() -> Data? {
    let stickers = [Sticker()]
    let jsonEncoder = JSONEncoder()
    let jsonResultData = try? jsonEncoder.encode(stickers)
    return jsonResultData
}

func createSnipppets() -> Data? {
    let snippets = [Snippet()]
    let jsonEncoder = JSONEncoder()
    let jsonResultData = try? jsonEncoder.encode(snippets)
    return jsonResultData
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

    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        Calendar.current.isDate(self.noon, inSameDayAs: date.noon)
    }
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
}

extension Date {
    func getNextMonth(offset: Int = 0) -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1 + offset, to: self)
    }

    func getPreviousMonth(offset: Int = 0) -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1 + offset, to: self)
    }
}

extension FileManager {
  static func sharedContainerURL() -> URL {
    return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: "group.de.vnzn.ThemeYourDay"
    )!
  }
}



