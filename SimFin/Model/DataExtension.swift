import Foundation

// MARK: - Add data objects
extension Data {
    // MARK: add
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
    func add(_ account: Account, completion: ((Error?, RuleId?) -> Void)? = nil) {
        let id = self.id
        accounts[id] = account
        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.account.rawValue)/\(id)").setData(account.data) { err in
            if let err = err {
                print(err)
            } else {
                print("Account successfully created")
            }
        }
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
    func add(_ rule: Rule, completion: ((Error?, RuleId?) -> Void)? = nil) {
        let id = self.id
        rules[id] = rule
        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.rule.rawValue)/\(id)").setData(rule.data) { err in
            print(err as Any)
            completion?(err, id)
        }
    }
}

// MARK: - Update data objects methods
extension Data {
    func updateAccount(id: String, name: String) {
        print("implementation is needed")
    }
    func save(transaction: FinTransaction, completion: ((Error?) -> Void)? = nil) {
        // FIXME: Add completion
        guard let id = transaction.id else {
            _ = add(transaction: transaction)
            return
        }
        delete(transactionWithId: id)
        _ = add(transaction: transaction)
    }
    func save(_ rule: Rule, completion: ((Error?, RuleId?) -> Void)? = nil) {
        // FIXME: change completion logic (after all)
        if let id = rule.id {
            delete(ruleWithId: id, completion: nil)
        }
        _ = add(rule, completion: completion)
        print(Data.shared.rules)
    }

    // MARK: delete data objects
}
extension Data {
    func delete(transactionWithId id: String, completion: ((Error?) -> Void)? = nil) {
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
        // FIXME: add completion
        //        completion?()
    }
    func delete(accountWithId id: AccountId, completion: ((Error?) -> Void)?) {
        accounts[id] = nil
        _ = transactions.filter { $0.value.from == id || $0.value.to == id }.map { delete(transactionWithId: $0.key) }
        _ = rules.filter { $0.value.from == id || $0.value.to == id }.map { delete(ruleWithId: $0.key) }
        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.account.rawValue)/\(id)").delete { err in
            completion?(err)
        }
    }
    func delete(ruleWithId id: RuleId, completion: ((Error?) -> Void)? = nil) {
        rules[id] = nil
        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.rule.rawValue)/\(id)").delete { err in
            completion?(err)
        }
    }
}
