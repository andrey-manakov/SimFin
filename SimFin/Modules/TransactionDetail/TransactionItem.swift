import Foundation

// MARK: - Definition of Transaction Item Enum
internal enum TransactionItem: String, CaseIterable {
    case from
    case to
    case amount
    case description
}
