import UIKit

class ViewController: UIViewController {
    
    private let maxNumberCount = 11
    private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)

    @IBOutlet weak var formatedNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatedNumberTextField.delegate = self
        formatedNumberTextField.keyboardType = .phonePad
    }
    
    private func format(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
        
        guard !(shouldRemoveLastDigit && phoneNumber.count <= 2) else { return "+" }
        
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
    
        if number.count > maxNumberCount {
            let maxIndex = number.index(number.startIndex, offsetBy: maxNumberCount)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        if shouldRemoveLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        
        switch number.count {
        case 2...4:
            let pattern = "(\\d{1})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2)", options: .regularExpression, range: regRange)
        case 5...7:
            let pattern = "(\\d{1})(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
        case 8...9:
            let pattern = "(\\d{1})(\\d{3})(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4", options: .regularExpression, range: regRange)
        default:
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        }

       return "+" + number
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullSting = (textField.text ?? "") + string
        textField.text = format(phoneNumber: fullSting, shouldRemoveLastDigit: range.length == 1)
        return false
    }
}
