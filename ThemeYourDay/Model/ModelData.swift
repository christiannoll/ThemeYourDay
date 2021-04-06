import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var days: [Day] = load("DayData.json")
    
    func writeJSON() {
        let filename = "DayData.json"
        let file = getDocumentsDirectory().appendingPathComponent(filename)
        
        do {
            //print(days[0].text)
            try JSONEncoder().encode(days).write(to: file, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
        
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


