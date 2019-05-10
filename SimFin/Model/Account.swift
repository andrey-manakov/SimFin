import Foundation

typealias AccountId = String

internal struct AccountFields {
    internal let id = AccountField.id.rawValue
    internal let name = AccountField.name.rawValue
    internal let type = AccountField.type.rawValue
    internal let amount = AccountField.amount.rawValue
}

struct Account {
    // MARK: - Static Properties
    internal static let fields = AccountFields()

    var id: AccountId?
    var name: String?
    var type: AccountType?
    var amount: Int?
}

extension Account: Codable {
}

enum AccountField: String {
    case id, name, type, amount
}

extension Account: DataObjectProtocol {
    var data: [String: Any] {
        return [Account.fields.name: name as Any, Account.fields.type: type?.rawValue as Any, Account.fields.amount: amount as Any]
    }
    /// Initializer used to create instance of `Account` from data loaded from FireStore
    ///
    /// - Parameter data: data as it is stored in FireStore
    init(_ data: [String: Any]) {
        for (key, value) in data {
            update(field: key, value: value)
        }
    }

    // MARK: - Methods

    /// Updates instance field with new value
    ///
    /// - Parameters:
    ///   - field: field name
    ///   - value: value of the field
    internal mutating func update(field: String, value: Any) {
        guard let property = AccountField(rawValue: field) else {
            return
        }
        switch property {
        case .id:
            self.id = value as? String

        case .name:
            self.name = value as? String

        case .type:
            if let value = value as? String {
                self.type = AccountType(rawValue: value)
            }

        case .amount:
            self.amount = value as? Int
        }
    }
}
