import SwiftUI

@Observable
class Tools {

    enum ToolType {
        case None, Foreground, Background, Textformat
    }

    var visibleTool = ToolType.None
    var canvasVisible = false
    var settingsVisible = false

    var saveThemeAsImage: @MainActor () -> Void
    var shareThemeAsImage: @MainActor () -> Void

    init(saveTheme: @escaping () -> Void, shareTheme: @escaping () -> Void) {
        saveThemeAsImage = saveTheme
        shareThemeAsImage = shareTheme
    }

    static func showShareSheet(fileName: String) {
        let file = FileManager.sharedContainerURL().appendingPathComponent(fileName)
        let url = NSURL.fileURL(withPath: file.path)
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}
