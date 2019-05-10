import UIKit

internal protocol TextFieldProtocol: AnyObject {
    var text: String? { get set }
    var delegate: UITextFieldDelegate? { get set }
    var isFirstResponder: Bool { get }
    var actionOnReturn: ((_ text: String?) -> Void)? { get set }

    func resignFirstResponder() -> Bool
    func becomeFirstResponder() -> Bool
}
