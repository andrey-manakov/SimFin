import Foundation

/// Service class for `TransactionListVC`
internal final class TransactionListService: ClassService {
    func getData() -> DataModelProtocol {
        print(data.transactions)
        let transactions = data.transactions.sorted { (first: (key: FinTransactionId, value: FinTransaction), second: (key: FinTransactionId, value: FinTransaction)) -> Bool in
            first.value.date ?? Date() > second.value.date ?? Date()
        }
        print(transactions)
        let rows = transactions.map { args -> DataModelRow in
            let (transactionId, transaction) = args
            return DataModelRow(id: transactionId, texts: [
                .left: "\(transaction.date ?? Date())",
                .up: data.accounts[transaction.from ?? ""]?.name, // data.getAccountName(id: transaction.from),
                .down: data.accounts[transaction.to ?? ""]?.name, // data.getAccountName(id: transaction.to),
                .right: "\(transaction.amount ?? 0)"])
        }
        print(rows)
//        let rows = data.transactions.map { args -> DataModelRow in
//            let (transactionId, transaction) = args
//            return DataModelRow(id: transactionId, texts: [
//                .left: "\(transaction.date ?? Date())",
//                .up: data.accounts[transaction.from ?? ""]?.name, // data.getAccountName(id: transaction.from),
//                .down: data.accounts[transaction.to ?? ""]?.name, // data.getAccountName(id: transaction.to),
//                .right: "\(transaction.amount ?? 0)"])
//        }
        return DataModel(rows)
    }

    func delete(row: DataModelRowProtocol?, completion: ((Error?) -> Void)? = nil) {
        guard let id = row?.id else {
            fatalError("Nil Id")
        }
        Data.shared.delete(FinTransaction(["id": id]), completion: completion)
    }

    func logOut(completion: ((Error?) -> Void)? = nil) {
        data.signOut(completion)
    }
}
