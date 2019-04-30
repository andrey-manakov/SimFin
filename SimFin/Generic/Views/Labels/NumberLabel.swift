import UIKit
/// Number Label
internal final class NumberLabel: SimpleLabel {
    // MARK: - Initializers
    /// Inititializes label with String
    ///
    /// Parameter _: text to show in label
    override internal init(_ text: String? = nil) {
        super.init(text)
        textAlignment = .right
    }
    /// Returns nil and implented since it is required
    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
