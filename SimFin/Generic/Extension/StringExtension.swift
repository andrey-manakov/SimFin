import Foundation
/// Date from string generators
extension String {
    /// Date from string with template "yyyy MMM-dd" for user interface
    internal var date: Date? { return DateFormatter("yyyy MMM-dd").date(from: self) }
    /// Returns date with format based on template provided
    ///
    /// Parameter withFormat: string template for date conversion  like "yyyy MMM-dd"
    internal func date(withFormat format: String) -> Date? {
        return DateFormatter(format).date(from: self)
    }
}
/// Extension for random String generation (used in Tests)
extension String {
    /// Returns random String with small latin letters with length provided
    ///
    /// Parameter length: required length of random String
    internal static func randomWithSmallLetters(length: Int = 10) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        return String((0...length - 1).map { _ in letters.randomElement() ?? Character("x") })
    }
}
