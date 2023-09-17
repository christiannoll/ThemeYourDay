import Foundation
import WidgetKit

final class ModelData: ObservableObject {
    @Published var selectedIndex = -1
    @Published var stickers = loadStickers()
    @Published var snippets = loadSnippets()
    @Published var selectedMyDay: MyDay? = nil
    
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
        WidgetCenter.shared.reloadTimelines(ofKind: "de.vnzn.ThemeYourDay.DayWidget")
    }
    
    func removeAllDays(_ days: [MyDay], settings: Settings) {
        for index in 0..<days.count {
            days[index].sticker = MySticker()
            days[index].bgColor = MyDay.defaultBgColor
            days[index].fgColor = DayColor()
            days[index].text = defaultWeekdayText(days[index].id, settings: settings)
        }
        informWidget()
    }
    
    func saveFgColor(r: Double, g: Double, b: Double, a: Double, settings: Settings?) {
        let color = DayColor(r: r, g: g, b: b, a: a)
        if let selectedMyDay {
            selectedMyDay.fgColor = color
            
            if let settings, !settings.fgColors.contains(color) {
                settings.fgColors.insert(color, at: 0)
                if settings.fgColors.count > 5 {
                    settings.fgColors = settings.fgColors.dropLast()
                }
            }
        }
    }
    
    func saveBgColor(r: Double, g: Double, b: Double, a: Double, settings: Settings?) {
        let color = DayColor(r: r, g: g, b: b, a: a)
        if let selectedMyDay {
            selectedMyDay.bgColor = color
            
            if let settings, !settings.bgColors.contains(color) {
                settings.bgColors.insert(color, at: 0)
                if settings.bgColors.count > 5 {
                    settings.bgColors = settings.bgColors.dropLast()
                }
            }
        }
    }
    
    func selectDay(_ date: Date, days: [MyDay]) {
        var index = -1
        for day in days {
            index += 1
            if day.id.hasSame(.day, as: date.noon) {
                selectedIndex = index
                selectedMyDay = day
                break
            }
        }
    }
    
    func selectDay(_ _day: MyDay, days: [MyDay]) {
        var index = -1
        for day in days {
            index += 1
            if day.id.hasSame(.day, as: _day.id.noon) {
                selectedIndex = index
                selectedMyDay = day
                break
            }
        }
    }
    
    func getToday(_ days: [MyDay]) -> MyDay? {
        let today = Date().noon
        var toDay: MyDay? = nil
        for day in days {
            if day.id.noon == today {
                toDay = day
                break
            }
        }
        return toDay
    }
    
    func applyToToday(_ days: [MyDay]) {
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
    
    func exportAsCsvFile(_ days: [MyDay], settings: Settings) {
        var csvString = "date,text\n"
        for day in days {
            if day.text != defaultWeekdayText(day.id, settings: settings) {
                let dataString = "\(day.id.description),\(day.text)\n"
                csvString = csvString.appending(dataString)
            }
        }
        writeCsvFile(csvString)
    }
    
    func isToday(day: MyDay?) -> Bool {
        guard let day = day else {
            return false
        }
        return day.id == Date().noon
    }
    
    func getSharedThemeFileName() -> String {
        guard let selectedMyDay else {
            return "Error"
        }
        let dateStr = selectedMyDay.id.formatted(.iso8601.day().month().year())
        let fileName = dateStr + "-Day.png"
        return fileName
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
        guard let selectedMyDay else {
            return FileManager.sharedContainerURL().appendingPathComponent("Error")
        }
        let filename = selectedMyDay.id.formatted(.iso8601) + ".img"
        let file = FileManager.sharedContainerURL().appendingPathComponent(filename)
        return file
    }
    
    private func getPngImageFilenameOfSelectedDay() -> URL {
        guard let selectedMyDay else {
            return FileManager.sharedContainerURL().appendingPathComponent("Error")
        }
        let filename = selectedMyDay.id.formatted(.iso8601) + ".png"
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



