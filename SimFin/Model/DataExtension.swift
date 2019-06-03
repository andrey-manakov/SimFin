import Foundation

extension Data {
    func addAccount(_ name: String, type: AccountType) -> AccountId {
        let id = self.id
        let account = Account(id: id, name: name, type: type, amount: 0)
        accounts[id] = account
        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.account.rawValue)/\(id)").setData(account.data) { err in
            if let err = err {
                print(err)
            } else {
                print("Account successfully created")
            }
        }
        return id
    }
    func updateAccount(id: String, name: String) {
        print("implementation is needed")
    }
    func getAccounts() -> [Account] {
        return Array(accounts.values)
    }
    func getAccounts(ofType type: AccountType) -> [Account] {
        return Array(accounts.values).filter { $0.type == type }
    }
    func getAccountName(id: AccountId?) -> String? {
        guard let id = id else {
            return nil
        }
        return accounts[id]?.name
    }
    func save(transaction: FinTransaction, completion: (() -> Void)? = nil) {
        // FIXME: Add completion
        guard let id = transaction.id else {
            _ = add(transaction: transaction)
            return
        }
        delete(transactionWithId: id)
        _ = add(transaction: transaction)
    }
    func add(transaction: FinTransaction) -> FinTransactionId? {
        let id = self.id
        // FIXME: check with guard
        guard let from = transaction.from, let to = transaction.to, let amount = transaction.amount else {
            return nil
        }
        let transaction = FinTransaction(id: id, from: from, to: to, amount: amount, description: transaction.description, date: transaction.date ?? Date())
        transactions[id] = transaction
        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.transaction.rawValue)/\(id)").setData(transaction.data)
        let fromAmount = (accounts[from]?.amount ?? 0) - amount
        accounts[from]?.amount = fromAmount
        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.account.rawValue)/\(from)").setData([Account.fields.amount: fromAmount], merge: true)
        let toAmount = (accounts[to]?.amount ?? 0) + amount
        accounts[to]?.amount = toAmount
        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.account.rawValue)/\(to)").setData([Account.fields.amount: toAmount], merge: true)
        return id
    }
    func delete(transactionWithId id: String, completion: (() -> Void)? = nil) {
        guard let transaction = transactions[id], let from = transaction.from, let to = transaction.to, let amount = transaction.amount else {
            return
        }
        transactions[id] = nil
        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.transaction.rawValue)/\(id)").delete()
        let fromAmount = (accounts[from]?.amount ?? 0) + amount
        accounts[from]?.amount = fromAmount
        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.account.rawValue)/\(from)").setData([Account.fields.amount: fromAmount], merge: true)

        let toAmount = (accounts[to]?.amount ?? 0) - amount
        accounts[to]?.amount = toAmount
        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.account.rawValue)/\(to)").setData([Account.fields.amount: toAmount], merge: true)
        completion?()
    }
    func delete(accountWithId id: String, completion: (() -> Void)?) {
        accounts[id] = nil
        _ = transactions.filter { $0.value.from == id || $0.value.to == id }.map { delete(transactionWithId: $0.key) }
        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.account.rawValue)/\(id)").delete()
    }
    func getTransactions() -> [FinTransaction] {
        return Array(transactions.values).sorted {
            ($0.date ?? Date()).isAfter(($1.date ?? Date()))
        }
    }
}
