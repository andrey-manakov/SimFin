import Foundation

// MARK: - Add data objects
extension Data {
    func add(_ account: Account, completion: ((Error?, AccountId?) -> Void)? = nil) {
        let id = self.id
//        accounts[id] = account
        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.account.rawValue)/\(id)").setData(account.data) { err in
            if let err = err {
                print(err)
            } else {
                print("Account successfully created")
            }
        }
    }
    func add(_ transaction: FinTransaction, completion: ((Error?, FinTransactionId?) -> Void)? = nil) {
        let id = self.id
        guard let from = transaction.from, let to = transaction.to, let amount = transaction.amount else {
            return
        }
        let transaction = FinTransaction(id: id, from: from, to: to, amount: amount, description: transaction.description, date: transaction.date ?? Date())

        _ = FIRFinTransactionManager(.create, transaction) { err in
            completion?(err, id)
            print("LOG FirManager created transaction")
        }
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
    func save(_ account: Account, completion: ((Error?) -> Void)? = nil) {
//        FIXME: implementation needed
    }
    func save(_ transaction: FinTransaction, completion: ((Error?) -> Void)? = nil) {
        // FIXME: Add completion
        guard let id = transaction.id else {
            _ = add(transaction)
            return
        }
        // FIXME: refactor logic - without delete of transaction
        delete(transaction) { [unowned self] err in
            if let err = err {
                print("LOG \(err.localizedDescription)")
            } else {
                _ = self.add(transaction)
            }
        }
    }
    func save(_ rule: Rule, completion: ((Error?, RuleId?) -> Void)? = nil) {
        // FIXME: change completion logic (after all)
        if let id = rule.id {
            delete(ruleWithId: id, completion: nil)
        }
        _ = add(rule, completion: completion)
        print(Data.shared.rules)
    }
}

// MARK: delete data objects
extension Data {
    func delete(_ transaction: FinTransaction, completion: ((Error?) -> Void)? = nil) {
        _ = FIRFinTransactionManager(.delete, transaction) { err in
            completion?(err)
            print("LOG transaction deleted")
        } 
//        guard let id = transaction.id else {
//            return
//        }
//        guard let transaction = transactions[id], let from = transaction.from, let to = transaction.to, let amount = transaction.amount else {
//            return
//        }
////        transactions[id] = nil
//        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.transaction.rawValue)/\(id)").delete { err in
//            if let err = err {
//                print(err.localizedDescription)
//            } else {
//                print("LOG Transaction was deleted")
//                completion?(err)
//            }
//        }
//        let fromAmount = (accounts[from]?.amount ?? 0) + amount
////        accounts[from]?.amount = fromAmount
//        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.account.rawValue)/\(from)").setData([Account.fields.amount: fromAmount], merge: true) { err in
//            if let err = err {
//                print(err.localizedDescription)
//            } else {
//                print("LOG from account was updated due to transaction delete")
//            }
//        }
//
//        let toAmount = (accounts[to]?.amount ?? 0) - amount
////        accounts[to]?.amount = toAmount
//        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.account.rawValue)/\(to)").setData([Account.fields.amount: toAmount], merge: true) { err in
//            if let err = err {
//                print(err.localizedDescription)
//            } else {
//                print("LOG from account was updated due to transaction delete")
//            }
//        }
//        // FIXME: add completion
//        //        completion?()
    }
    func delete(_ account: Account, completion: ((Error?) -> Void)? = nil) {
        _ = FIRAccountManager(.delete, account) { err in
            completion?(err)
            print("LOG account deleted")
        }
    }
//    func delete(accountWithId id: AccountId, completion: ((Error?) -> Void)?) {
//        // TODO: consider uncommenting to ensure immidiate update
//        //        accounts[id] = nil
//        _ = transactions.filter { $0.value.from == id || $0.value.to == id }.map { delete(FinTransaction(["id": $0.key])) }
//        _ = rules.filter { $0.value.from == id || $0.value.to == id }.map { delete(ruleWithId: $0.key) }
//        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.account.rawValue)/\(id)").delete { err in
//            completion?(err)
//        }
//    }
    func delete(ruleWithId id: RuleId, completion: ((Error?) -> Void)? = nil) {
//        rules[id] = nil
        Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.rule.rawValue)/\(id)").delete { err in
            completion?(err)
        }
    }
}

// MARK: - Setting listners
extension Data {
    func setListners() {
        setListnerToAccount()
        setListnerToTransaction()
        setListnerToRule()
    }
    private func setListnerToAccount() {
        let path = "users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.account.rawValue)"
        Firestore.firestore().collection(path).addSnapshotListener { [unowned self] snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshots: \(error?.localizedDescription ?? "")")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if diff.type == .added || diff.type == .modified {
                    let data = diff.document.data().merging([Account.fields.id: diff.document.documentID]) { _, new in new }
                    self.accounts[diff.document.documentID] = Account(data)
                }
                if diff.type == .removed {
                    self.accounts[diff.document.documentID] = nil
                }
            }
            TabBarController.shared.reload()
        }
    }
    private func setListnerToTransaction() {
        let path = "users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.transaction.rawValue)"
        Firestore.firestore().collection(path).addSnapshotListener { [unowned self] snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshots: \(error?.localizedDescription ?? "")")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if diff.type == .added || diff.type == .modified {
                    let data = diff.document.data().merging([FinTransaction.fields.id: diff.document.documentID]) { _, new in new }
                    self.transactions[diff.document.documentID] = FinTransaction(data)
                }
                if diff.type == .removed {
                    self.transactions[diff.document.documentID] = nil
                }
            }
            TabBarController.shared.reload()
        }
    }
    private func setListnerToRule() {
        let path = "users/\(Auth.auth().currentUser?.uid ?? "")/\(DataObjectType.rule.rawValue)"
        Firestore.firestore().collection(path).addSnapshotListener { [unowned self] snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshots: \(error?.localizedDescription ?? "")")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if diff.type == .added || diff.type == .modified {
                    // FIXME: replace with reference to field name
//                    let dictionary = ["a": 1, "b": 2]
//                    let newKeyValues = ["a": 3, "b": 4]
//
//                    let keepingCurrent = dictionary.merging(newKeyValues) { (current, _) in current }
//                    // ["b": 2, "a": 1]
//
//                    let replacingCurrent = dictionary.merging(newKeyValues) { (_, new) in new }
//                    let data = diff.document.data().merging(["id" : diff.document.documentID], uniquingKeysWith: { (x, y) -> Any in
//                        return x
//                    })
                    let data = diff.document.data().merging([Rule.fields.id: diff.document.documentID]) { _, new in new }
                    self.rules[diff.document.documentID] = Rule(data)
                    print(data)
                }
                if diff.type == .removed {
                    self.rules[diff.document.documentID] = nil
                }
            }
            TabBarController.shared.reload()
        }
    }
}

// MARK: - Sign In, Sign Out
extension Data {
    internal func signOut(_ completion: ((Error?) -> Void)? = nil) {
        fireAuth?.signOutUser(completion)
    }

    internal func signInUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?) {
        fireAuth?.signInUser(withEmail: email, password: pwd, completion: completion)
    }

    internal func signUpUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?) {
        fireAuth?.createUser(withEmail: email, password: pwd, completion: completion)
    }

    internal func deleteUser(completion: ((Error?) -> Void)?) {
        fireAuth?.deleteUser(completion)
    }
}
