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
                for document in querySnapshot!.documents {
                    var transaction = FinTransaction(document.data())
                    transaction.id = document.documentID
                    transactions[document.documentID] = transaction
                    print("\(document.documentID) => \(document.data())")
                }
                completion?(transactions)
            }
        }
    }

    internal func create(_ finTransaction: FinTransaction, completion: ((String?) -> Void)? = nil) {
    }
}
