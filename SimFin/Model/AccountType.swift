import Foundation

enum AccountType: String, CaseIterable {
    case asset
    case liability
    case revenue
    case expense
    case capital

    internal var active: Bool {
        return self == .asset || self == .expense ? true : false
    }
}
