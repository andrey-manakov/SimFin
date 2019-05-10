import UIKit

internal final class PasswordField: SimpleTextField {
    override internal init(_ placeholder: String? = nil, _ actionOnReturn: ((_ text: String?) -> Void)? = nil) {
        super.init(placeholder, actionOnReturn)
        isSecureTextEntry = true
        self.actionOnReturn = actionOnReturn
        self.delegate = self
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
