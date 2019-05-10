import Foundation
/// Extension of Date
extension Date {
    /// Month number
    internal var month: Int? { return Calendar.current.dateComponents([.month], from: self).month }
    /// Month name string
    internal var monthString: String? { return DateFormatter("LLLL").string(from: self) }
    /// Day Number
    internal var day: Int? { return Calendar.current.dateComponents([.day], from: self).day }
    /// Day in local time zone
    internal var localDay: Int? {
        let dateFormatter = DateFormatter("dd")
        dateFormatter.timeZone = TimeZone.current
        return Int(dateFormatter.string(from: self))
    }
    /// Year number
    internal var year: Int? { return Calendar.current.dateComponents([.year], from: self).year }
    //    var day: Int
}
/// Extension to add functionality of Date comparison
extension Date {
    /// Returns true if dates are queal
    internal func isSameDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedSame
    }
    /// Returns true if one date is before another
    internal func isBeforeDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedAscending
    }
    /// Returns true if one date is after another
    internal func isAfterDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedDescending
    }
    /// Returns true if one date is after another
    internal func isAfter(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .nanosecond)
        return order == .orderedDescending
    }
}
/// Extension adds functionality to check if date is weekend
extension Date {
    /// Returns number of the day inside a week
    internal func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    /// Returns true if date is in weekend
    internal func isWeekEnd() -> Bool {
        let weekDay = Calendar.current.dateComponents([.weekday], from: self).weekday
        return (weekDay == 1 || weekDay == 7) ? true : false
    }
}
/// Extends functionality to add conversion from date to string
extension Date {
    /// Returns string for user interface
    internal var string: String { return DateFormatter("yyyy MMM-dd").string(from: self) }
    /// Returns string converted to database path (not used now)
    internal var strFireBasePath: String { return DateFormatter("/yyyy/MM/dd").string(from: self) }
    /// Returns string formatted according to provided template
    ///
    /// Parameter _: format template like "yyyy MMM-dd"
    internal func str(_ format: String) -> String {
        return DateFormatter(format).string(from: self)
    }
}
