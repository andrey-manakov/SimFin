import UIKit
/// Extension to add subviews with one command based on Visual Formatting
extension UIView {
    /// Adds subviews to UIView based on Visual Formatting
    ///
    /// - Parameters:
    ///   - views: dictionary of views to add
    ///   - constraints: array of Visual Formatting strings to apply
    ///
    /// Note: func sets accessibilityIdentifier for subview equal to views dict keys
    internal func add(views: [String: UIView?], withConstraints constraints: [String] = ["H:|[v]|", "V:|[v]|"]) {
        guard let views = views as? [String: UIView] else {
            print("error in addSubviewsWithConstraints")
            return
        }
        for (accessibilityIdentifier, view) in views {
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.accessibilityIdentifier = accessibilityIdentifier
        }

        for index in 0..<constraints.count {
            self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: constraints[index],
                    options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                    metrics: nil,
                    views: views
                )
            )
        }
    }
    /// Adds one subview to UIView with constraints
    ///
    /// Parameters:
    /// - view: subview to add
    /// - constraints: array of Visual Formatting strings to apply
    internal func add(view: UIView?, withConstraints constraints: [String] = ["H:|[v]|", "V:|[v]|"]) {
        add(views: ["v": view], withConstraints: constraints)
    }
    internal func add(view: Any?, withConstraints constraints: [String] = ["H:|[v]|", "V:|[v]|"]) {
        if let view = view as? UIView {
            add(views: ["v": view], withConstraints: constraints)
        }
    }
    /// Views dictionary with keys equal to accessibilityIdentifier
    internal var views: [String: UIView] {
        var views = [String: UIView]()
        for view in self.subviews {
            guard let id = view.accessibilityIdentifier else { continue }
            views[id] = view
        }
        return views
    }
    // TODO: consider moving to parent class
    /// Unique id of UIView Instance
    internal var id: String { return ObjectIdentifier(self).debugDescription }
}
