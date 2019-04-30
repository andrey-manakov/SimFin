import Foundation
internal class TransactionDetailService: ClassService {
    func save(_ transaction: Transaction?) -> Bool {
        if let transaction = transaction {
            return type(of: (data.add(transaction: transaction))) == String.self
        } else {
            return false
        }
    }

    func getTransactionData(transaction: Transaction, item: TransactionItem) -> String? {
        switch item {
        case .from:
            guard let from = transaction.from else {
                return nil
            }
            return data.getAccountName(id: from)

        case .to:
            guard let to = transaction.to else {
                return nil
            }
            return data.getAccountName(id: to)

        case .amount:
            return "\(transaction.amount ?? 0)"

        case .description:
            return transaction.description ?? ""
        }
    }
}
