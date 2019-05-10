import Foundation

extension AccountType: Codable {
    enum Key: CodingKey {
        case rawValue
    }

    enum CodingError: Error {
        case unknownValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)
        switch rawValue {
        case "asset":
            self = .asset

        case "liability":
            self = .liability

        case "revenue":
            self = .revenue

        case "expense":
            self = .expense

        case "capital":
            self = .capital

        default:
            throw CodingError.unknownValue
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .asset:
            try container.encode("asset", forKey: .rawValue)

        case .liability:
            try container.encode("liability", forKey: .rawValue)

        case .revenue:
            try container.encode("revenue", forKey: .rawValue)

        case .expense:
            try container.encode("expense", forKey: .rawValue)

        case .capital:
            try container.encode("capital", forKey: .rawValue)
        }
    }
}
