import UIKit

internal final class RightNumberField: UITextField, TextFieldProtocol {
    internal var actionOnReturn: ((_ text: String?) -> Void)?

    internal init(_ placeholder: String? = nil) {
        super.init(frame: .zero)
        textAlignment = .right
        keyboardType = .numberPad
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
