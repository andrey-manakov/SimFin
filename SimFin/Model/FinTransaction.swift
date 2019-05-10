import Foundation

typealias FinTransactionId = String

struct FinTransaction {
    var id: FinTransactionId?
    var from: String?
    var to: String?
    var amount: Int?
    var description: String?
    var date: Date?
}

extension FinTransaction: Codable {
}

enum FinTransactionField: String {
    case id, from, to, amount, description, date
}

internal struct FinTransactionFields {
    internal let id = FinTransactionField.id.rawValue
    internal let from = FinTransactionField.from.rawValue
    internal let to = FinTransactionField.to.rawValue
    internal let amount = FinTransactionField.amount.rawValue
    internal let date = FinTransactionField.date.rawValue
    internal let description = FinTransactionField.description.rawValue
}

extension FinTransaction: DataObjectProtocol {
    // MARK: - Static Properties
    internal static let fields = FinTransactionFields()
    var data: [String: Any] {
        return [FinTransaction.fields.from: from as Any, FinTransaction.fields.to: to as Any, FinTransaction.fields.amount: amount as Any, FinTransaction.fields.date: date as Any, FinTransaction.fields.description: description as Any]
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
        guard let property = FinTransactionField(rawValue: field) else {
            return
        }
        switch property {
        case .id:
            self.id = value as? String

        case .from:
            self.from = value as? String

        case .to:
            self.to = value as? String

        case .amount:
            self.amount = value as? Int

        case .description:
            self.to = value as? String

        case .date:
            self.date = (value as? Timestamp)?.dateValue()
        }
    }
}
