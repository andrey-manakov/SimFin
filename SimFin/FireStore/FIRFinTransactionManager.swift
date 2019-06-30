internal protocol FIRFinTransactionManagerProtocol: AnyObject {
    //    func create(_ finTransaction: FinTransaction, completion: ((String?) -> Void)?)
    //    func loadAll(_ completion: (([FinTransactionId: FinTransaction]) -> Void)?)
}

extension FIRFinTransactionManager: FireStoreCompletionProtocol, FireStoreGettersProtocol {}

internal final class FIRFinTransactionManager: FIRManager, FIRFinTransactionManagerProtocol {

    var transaction: FinTransaction?
    var completion: ((Error?) -> Void)?

    init(_ action: FIRManager.Action, _ transaction: FinTransaction? = nil, completion: ((Error?) -> Void)? = nil) {
        self.transaction = transaction
        self.completion = completion
        super.init()

        switch action {
        case .create:
            fireDB.runTransaction(create(fsTransaction:errorPointer:), completion: fireStoreCompletion)

        case .delete:
            fireDB.runTransaction(delete(fsTransaction:errorPointer:), completion: fireStoreCompletion)
        }
    }

    private func create(fsTransaction: Transaction, errorPointer: NSErrorPointer) -> Any? {
        guard
            let fromAccount = self.get(Account([Account.fields.id: transaction?.from as Any]), for: fsTransaction, with: errorPointer),
            let toAccount = self.get(Account([Account.fields.id: transaction?.to as Any]), for: fsTransaction, with: errorPointer),
            let ref = ref,
            let transaction = transaction,
            let transactionAmount = transaction.amount,
            let transactionId = transaction.id else {
                return nil
        }
        let newTransactionRef = ref.collection(DataObjectType.transaction.rawValue).document(transactionId)
        fsTransaction.setData(transaction.data, forDocument: newTransactionRef)

        for (account, coef) in [(fromAccount, -1), (toAccount, 1)] {
            guard let id = account.id else {
                break
            }
            let newAmount = (account.amount ?? 0) + transactionAmount * coef
            let fields = Account.fields
            let newAccountData: [String: Any] = [fields.amount: newAmount]
            let newAccountRef = ref.collection(DataObjectType.account.rawValue).document(id)
            fsTransaction.updateData(newAccountData, forDocument: newAccountRef)
        }
        return {
            self.completion?(nil)
            print("Transaction created")
        }
    }

    private func delete(fsTransaction: Transaction, errorPointer: NSErrorPointer) -> Any? {
        let fromAccountId = Account([Account.fields.id: transaction?.from])
        print(fromAccountId)

        guard let inputTransaction = transaction,
            let transaction = self.get(inputTransaction, for: fsTransaction, with: errorPointer),
            let ref = ref,
            let transactionAmount = transaction.amount,
            let transactionId = transaction.id else {
                return nil
        }
        let fromAccount = self.get(Account([Account.fields.id: transaction.from as Any]), for: fsTransaction, with: errorPointer)
        let toAccount = self.get(Account([Account.fields.id: transaction.to as Any]), for: fsTransaction, with: errorPointer)

        let transactionRef = ref.collection(DataObjectType.transaction.rawValue).document(transactionId)
        fsTransaction.deleteDocument(transactionRef)

        for (account, coef) in [(fromAccount, 1), (toAccount, -1)] {
            guard let account = account, let id = account.id else {
                break
            }
            let newAmount = (account.amount ?? 0) + transactionAmount * coef
            let fields = Account.fields
            let newAccountData: [String: Any] = [fields.amount: newAmount]
            let newAccountRef = ref.collection(DataObjectType.account.rawValue).document(id)
            fsTransaction.updateData(newAccountData, forDocument: newAccountRef)
        }
        return {
            self.completion?(nil)
            print("LOG Transaction deleted")
        }
    }

    //    func loadAll(_ completion: (([FinTransactionId: FinTransaction]) -> Void)?) {
    //        var transactions = [FinTransactionId: FinTransaction]()
    //        self.ref?.collection(DataObjectType.transaction.rawValue).getDocuments { querySnapshot, err in
    //            if let err = err {
    //                print("Error getting documents: \(err)")
    //                completion?(transactions)
    //            } else {
    //                // FIXME: delete in production
    //                let docData = querySnapshot!.documents.map { $0.data() }
    //                let amountAndToData = docData.map { ($0["to"] as? String, $0["amount"] as? Int) }
    //                _ = amountAndToData.map { print($0) }
    //                // end delete
    //                for document in querySnapshot!.documents {
    //                    var transaction = FinTransaction(document.data())
    //                    transaction.id = document.documentID
    //                    transactions[document.documentID] = transaction
    //                }
    //                completion?(transactions)
    //                _ = Array(transactions.values).map { ($0.to, $0.amount) }.map { print($0) }
    //            }
    //        }
    //    }
    //
    //    internal func create(_ finTransaction: FinTransaction, completion: ((String?) -> Void)? = nil) {
    //        fireDB.runTransaction(updateBlock(fsTransaction:errorPointer:), completion: fireStoreCompletion)
    //    }
}
