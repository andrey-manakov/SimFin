import UIKit

internal protocol ButtonProtocol {
}

internal final class Button: UIButton, ButtonProtocol {
    internal var action: (() -> Void)?

    internal init(name: String, action: @escaping () -> Void) {
        super.init(frame: CGRect.zero)
        self.action = action
        setTitle(name, for: UIControl.State.normal)
        setTitleColor(.red, for: UIControl.State.normal)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.red.cgColor
        layer.cornerRadius = 15.0
        self.addTarget(self, action: #selector(tapAction), for: UIControl.Event.touchUpInside)
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }

    @objc internal func tapAction() {
        action?()
    }
}
