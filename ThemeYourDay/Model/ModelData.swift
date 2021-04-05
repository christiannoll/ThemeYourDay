import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var days: [Day] = load("DayData.json")
    
    func writeJSON() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let jsonURL = documentDirectory
            .appendingPathComponent("DayData")
            .appendingPathExtension("json")
        try? JSONEncoder().encode(days).write(to: jsonURL, options: .atomic)
    }
}

func load<T: Codable>(_ filename: String) -> T {
    let data: Data
        
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


