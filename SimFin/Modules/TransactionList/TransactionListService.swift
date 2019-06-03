import Foundation

/// Service class for `TransactionListVC`
internal final class TransactionListService: ClassService {
    func getData() -> DataModelProtocol {
        let rows = data.getTransactions().map {
            DataModelRow(id: $0.id, texts: [
                .left: "\($0.date ?? Date())",
                .up: data.getAccountName(id: $0.from),
                .down: data.getAccountName(id: $0.to),
                .right: "\($0.amount ?? 0)"])
        }
        print(rows.count)
        return DataModel(rows)
    }

    func delete(row: DataModelRowProtocol?, completion: (() -> Void)? = nil) {
        guard let id = row?.id else {
            fatalError("Nil Id")
        }
        Data.shared.delete(transactionWithId: id, completion: completion)
        completion?()
    }

    func logOut(completion: ((Error?) -> Void)? = nil) {
        data.signOut(completion)
    }
}
