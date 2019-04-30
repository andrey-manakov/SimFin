import Foundation

typealias AccountId = String

struct Account {
    var id: AccountId?
    var name: String?
    var type: AccountType?
    var amount: Int?
}

extension Account: Codable {
}
