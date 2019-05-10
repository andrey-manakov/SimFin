import Foundation
/// Extension allows to initialize Date Formatter with one command
extension DateFormatter {
    /// Initializes DateFormatter with string format
    ///
    /// Paramenter _: format template like "yyyy MMM-dd"
    internal convenience init(_ format: String? = nil) {
        self.init()
        self.dateFormat = format
    }
}
