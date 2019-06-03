import Foundation
internal class TransactionDetailService: ClassService {
    func save(_ transaction: FinTransaction?) {
        guard let transaction = transaction else {
            return
        }
        data.save(transaction: transaction) {
            print("")
        }
    }

    func getTransactionData(transaction: FinTransaction, item: TransactionItem) -> String? {
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

    func getFinTrasnsaction(withId id: FinTransactionId) -> FinTransaction? {
        return Data.shared.transactions[id]
    }
}
