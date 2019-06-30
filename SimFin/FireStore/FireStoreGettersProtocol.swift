/// Getters for FireStore Transactions (reads before atomic write)
internal protocol FireStoreGettersProtocol {
    var ref: DocumentReference? { get }
}

extension FireStoreGettersProtocol {
    internal func getUserData(
        for fsTransaction: Transaction,
        with errorPointer: NSErrorPointer = nil
        ) -> DocumentSnapshot? {
        guard let ref = ref else {
            return nil
        }
        let doc: DocumentSnapshot
        do {
            try doc = fsTransaction.getDocument(ref)
        } catch let fetchError as NSError {
            errorPointer?.pointee = fetchError
            return nil
        }
        return doc
    }

    internal func get(
        _ dataObject: DataObjectType,
        withId id: String?,
        for fsTransaction: Transaction,
        with errorPointer: NSErrorPointer = nil
        ) -> DataObjectProtocol? {
        guard let ref = ref, let id = id else {
            return nil
        }
        let doc: DocumentSnapshot
        do {
            try doc = fsTransaction.getDocument(ref.collection(dataObject.rawValue).document(id))
        } catch let fetchError as NSError {
            errorPointer?.pointee = fetchError
            return nil
        }
        guard var data = doc.data() else {
            return nil
        }
        data["id"] = id
        switch dataObject {
        case .account:
            return Account(data)

        case .transaction:
            return FinTransaction(data)

        case .rule:
            return Rule(data)
        }
    }

    internal func get(_ account: Account, for fsTransaction: Transaction, with errorPointer: NSErrorPointer = nil) -> Account? {
        print(account.id)
        print(account)
        return get(.account, withId: account.id, for: fsTransaction, with: errorPointer) as? Account
    }

    internal func get(_ transaction: FinTransaction, for fsTransaction: Transaction, with errorPointer: NSErrorPointer = nil) -> FinTransaction? {
        return get(.transaction, withId: transaction.id, for: fsTransaction, with: errorPointer) as? FinTransaction
    }

    internal func getAccount(
        withId id: String?,
        for fsTransaction: Transaction,
        with errorPointer: NSErrorPointer = nil
        ) -> Account? {
        return get(.account, withId: id, for: fsTransaction, with: errorPointer) as? Account
    }

    internal func getTransaction(
        withId id: String?,
        for fsTransaction: Transaction,
        with errorPointer: NSErrorPointer = nil
        ) -> FinTransaction? {
        return get(.transaction, withId: id, for: fsTransaction, with: errorPointer) as? FinTransaction
    }

    internal func getAmount(
        ofAccount id: String?,
        for fsTransaction: Transaction,
        with errorPointer: NSErrorPointer = nil
        ) -> Int? {
        return getAccount(withId: id, for: fsTransaction, with: errorPointer)?.amount
    }
}
