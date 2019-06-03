internal protocol FIRFinTransactionManagerProtocol: AnyObject {
    func create(_ finTransaction: FinTransaction, completion: ((String?) -> Void)?)
    func loadAll(_ completion: (([FinTransactionId: FinTransaction]) -> Void)?)
}

extension FIRFinTransactionManager: FireStoreCompletionProtocol, FireStoreGettersProtocol {}

internal final class FIRFinTransactionManager: FIRManager, FIRFinTransactionManagerProtocol {
    /// Singlton
    internal static var shared: FIRFinTransactionManagerProtocol = FIRFinTransactionManager()

    override private init() {}

    func loadAll(_ completion: (([FinTransactionId: FinTransaction]) -> Void)?) {
        var transactions = [FinTransactionId: FinTransaction]()
        self.ref?.collection(DataObjectType.transaction.rawValue).getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
                completion?(transactions)
            } else {
                // FIXME: delete in production
                let docData = querySnapshot!.documents.map { $0.data() }
                let amountAndToData = docData.map { ($0["to"] as? String, $0["amount"] as? Int) }
                print("24")
                _ = amountAndToData.map { print($0) }
                // end delete
                for document in querySnapshot!.documents {
                    var transaction = FinTransaction(document.data())
                    transaction.id = document.documentID
                    transactions[document.documentID] = transaction
                    print("31")
                    print((transaction.to, transaction.amount))
//                    print("\(document.documentID) => \(document.data())")
                }
                completion?(transactions)
                print("35")
                _ = Array(transactions.values).map { ($0.to, $0.amount) }.map { print($0) }
            }
        }
    }

    internal func create(_ finTransaction: FinTransaction, completion: ((String?) -> Void)? = nil) {
    }
}
