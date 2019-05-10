import UIKit

internal class SimpleTextField: UITextField, TextFieldProtocol, UITextFieldDelegate {
    private let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    internal var actionOnReturn: ((_ text: String? ) -> Void)?

    internal init(_ placeholder: String? = nil, _ actionOnReturn: ((_ text: String? ) -> Void)? = nil) {
        super.init(frame: CGRect.zero)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 10.0
        autocorrectionType = .no
        autocapitalizationType = .none
        spellCheckingType = .no
        self.placeholder = placeholder
        self.actionOnReturn = actionOnReturn
        self.delegate = self
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override internal func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override internal func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override internal func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    deinit {
        print("deinit \(type(of: self))")
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        actionOnReturn?(self.text)
        return true
    }
}
