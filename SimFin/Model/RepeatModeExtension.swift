import Foundation

extension RepeatMode: Codable {
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
        case "daily":
            self = .daily

        case "weekly":
            self = .weekly

        case "monthly":
            self = .monthly

        case "annually":
            self = .annually

        default:
            throw CodingError.unknownValue
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .daily:
            try container.encode("daily", forKey: .rawValue)

        case .weekly:
            try container.encode("weekly", forKey: .rawValue)

        case .monthly:
            try container.encode("monthly", forKey: .rawValue)

        case .annually:
            try container.encode("annually", forKey: .rawValue)
        }
    }
}
