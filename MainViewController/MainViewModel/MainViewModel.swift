
import Foundation

class MainViewModel {

    private(set) var buttonAlpha = 0.4
    private(set) var isButtonEnabled = false
    
    func updateName(_ name: String, _ nameTwo: String) {
        if name.count > 1 && nameTwo.count > 1 {
            buttonAlpha = 1
            isButtonEnabled = true
        } else {
            buttonAlpha = 0.4
            isButtonEnabled = false
        }
    }
}
