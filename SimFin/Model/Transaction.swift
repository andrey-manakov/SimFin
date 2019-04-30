import Foundation

typealias TransactionId = String

struct Transaction {
    var id: TransactionId?
    var from: String?
    var to: String?
    var amount: Int?
    var description: String?
    var date: Date?
}

extension Transaction: Codable {
}
