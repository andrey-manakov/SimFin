import UIKit
internal final class BarButtonItem: UIBarButtonItem {
    internal var tapAction: (() -> Void)?

    internal convenience init(assetName: String, action: (() -> Void)?) {
        let barButton = UIButton(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        let barButtonImage = UIImage(named: assetName)?.withRenderingMode(.alwaysTemplate)
        barButton.setImage(barButtonImage, for: .normal)
        barButton.tintColor = UIColor.white
        self.init(customView: barButton)
        self.action = #selector(didTap)
        if let action = self.action {
            barButton.addTarget(self, action: action, for: .touchUpInside)
        }
    }

    internal convenience init(_ title: String, _ action: (() -> Void)?) {
        let barButton = UIButton(frame: .zero)
        barButton.sizeToFit()
        barButton.setTitle(title, for: UIControl.State.normal)
        barButton.setTitleColor(barButton.tintColor, for: .normal)
        barButton.setTitleColor(.lightGray, for: .selected)
        self.init(customView: barButton)
        self.tapAction = action
        barButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        self.action = #selector(didTap)
    }

    override private init() {
        super.init()
    }
    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }

    @objc internal func didTap() {
        tapAction?()
    }
}
