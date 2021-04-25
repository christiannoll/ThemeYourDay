import UIKit
import SwiftUI

struct FontPickerView: UIViewControllerRepresentable {

    @Binding var font: String
    @Binding var isShow: Bool

    func makeUIViewController(context: UIViewControllerRepresentableContext<FontPickerView>) -> UIViewController {
        return UIViewController()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, font: font)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController,
                                           context: UIViewControllerRepresentableContext<FontPickerView>) {
        if isShow {
            let picker = UIFontPickerViewController()
            picker.delegate = context.coordinator
            picker.title = "Select Font"
            
            uiViewController.present(picker, animated: true)
        }
    }
    
    func toogleVisibility() {
        isShow.toggle()
    }
}
    
class Coordinator: NSObject, UIFontPickerViewControllerDelegate {

    var fontView: FontPickerView
    var font: String


    init(_ control: FontPickerView, font: String) {
        self.fontView = control
        self.font = font
    }

    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        guard let descriptor = viewController.selectedFontDescriptor else {
            return
        }
        let selectedFont = UIFont(descriptor: descriptor, size: 30)
        fontView.font = selectedFont.fontName
        fontView.toogleVisibility()
    }
    
    func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController) {
        fontView.toogleVisibility()
    }
}

