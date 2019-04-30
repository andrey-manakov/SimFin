import UIKit
/// Protocol to access `SimpleLabel`
internal protocol SimpleLabelProtocol {
    var text: String? { get set }
}

/// Subclass of UILabel with basic settings, to be used as a base class through out the app
internal class SimpleLabel: UILabel, SimpleLabelProtocol {
    // MARK: - Initializers
    /// Initializes with text to be shown
    ///
    /// - Parameter text: text to be shown in label
    internal init(_ text: String? = nil) {
        super.init(frame: CGRect.zero)
        self.text = text
        lineBreakMode = .byWordWrapping
        numberOfLines = 2
    }

    /// Initializer with additional formatting options
    ///
    /// - Parameters:
    ///   - text: text to be shown
    ///   - alignment: text alignment
    ///   - lines: number of lines in label
    internal convenience init(_ text: String? = nil, alignment: NSTextAlignment? = nil, lines: Int? = nil) {
        self.init(text)
        if let alignment = alignment {
            self.textAlignment = alignment
        }
        if let lines = lines {
            self.numberOfLines = lines
        }
    }

    /// Returns nil and implented since it is required
    ///
    /// - Parameter aDecoder: coder token to decode data
    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
