import Foundation

// MARK: - Definition of Rule Item Enum
internal enum RuleItem: String, CaseIterable {
    case from, to, amount, ratio, baseAccount, dateBegin, dateBeginSelection, dateEnd, dateEndSelection, dateLastExecution, repeatMode, description
}
