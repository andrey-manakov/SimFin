import Foundation

typealias RuleId = String

struct Rule {
    var id: RuleId?
    var from: AccountId?
    var to: AccountId?
    var amount: Int?
    var ratio: Double?
    var baseAccount: AccountId?
    var description: String?
    var beginDate: Date?
    var endDate: Date?
    var lastExecutionDate: Date?
    var repeatMode: RepeatMode?
}

extension Rule: Codable {
}

enum RuleField: String {
    case id, from, to, amount, ratio, baseAccount, description, beginDate, endDate, lastExecutionDate, repeatMode
}

internal struct RuleFields {
    internal let id = RuleField.id.rawValue
    internal let from = RuleField.from.rawValue
    internal let to = RuleField.to.rawValue
    internal let amount = RuleField.amount.rawValue
    internal let ratio = RuleField.ratio.rawValue
    internal let baseAccount = RuleField.baseAccount.rawValue
    internal let description = RuleField.description.rawValue
    internal let beginDate = RuleField.beginDate.rawValue
    internal let endDate = RuleField.endDate.rawValue
    internal let lastExecutionDate = RuleField.lastExecutionDate.rawValue
    internal let repeatMode = RuleField.repeatMode.rawValue
}

extension Rule: DataObjectProtocol {
    // MARK: - Static Properties
    internal static let fields = RuleFields()
    var data: [String: Any] {
        return [Rule.fields.from: from as Any,
                Rule.fields.to: to as Any,
                Rule.fields.amount: amount as Any,
//                Rule.fields.beginDate: beginDate as Any,
//                Rule.fields.endDate: endDate as Any,
//                Rule.fields.lastExecutionDate: lastExecutionDate as Any,
                Rule.fields.description: description as Any]
    }

    /// Initializer used to create instance of `Account` from data loaded from FireStore
    ///
    /// - Parameter data: data as it is stored in FireStore
    init(_ data: [String: Any]) {
        print("preinit \(data["to"] ?? "") \(data["amount"] ?? "")")
        for (key, value) in data {
            update(field: key, value: value)
        }
        print("init \(self.to ?? "") \(self.amount ?? 0)")
    }

    // MARK: - Methods

    /// Updates instance field with new value
    ///
    /// - Parameters:
    ///   - field: field name
    ///   - value: value of the field
    internal mutating func update(field: String, value: Any) {
        guard let property = RuleField(rawValue: field) else {
            return
        }
        switch property {
        case .id:
            self.id = value as? String

        case .from:
            self.from = value as? String

        case .to:
            self.to = value as? String
            print("self \(self)")

        case .amount:
            self.amount = value as? Int

        case .ratio:
            self.ratio = value as? Double

        case .baseAccount:
            self.baseAccount = value as? String

        case .description:
            self.description = value as? String

        case .beginDate:
            self.beginDate = (value as? Timestamp)?.dateValue()

        case .endDate:
            self.endDate = (value as? Timestamp)?.dateValue()

        case .lastExecutionDate:
            self.lastExecutionDate = (value as? Timestamp)?.dateValue()

        case .repeatMode:
            if let value = value as? String {
                self.repeatMode = RepeatMode(rawValue: value)
            }
        }
    }
}
