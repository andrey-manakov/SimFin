internal protocol FIRAccountManagerProtocol {
    func createAccount(
        _ name: String?,
        ofType type: AccountType?,
        completion: ((String?) -> Void)?
    )
    func updateAccount(withId id: String?, name: String?, amount: Int?, completion: (() -> Void)?)
    func loadAll(_ completion: (([AccountId: Account]) -> Void)?)
}

extension FIRAccountManagerProtocol {
    func updateAccount(withId id: String?, amount: Int?, completion: (() -> Void)?) {
        updateAccount(withId: id, name: nil, amount: amount, completion: completion)
    }
}

extension FIRAccountManager: FireStoreCompletionProtocol, FireStoreGettersProtocol {}

internal final class FIRAccountManager: FIRManager, FIRAccountManagerProtocol {
    internal static var shared: FIRAccountManagerProtocol = FIRAccountManager()

    override private init() {}
    // FIXME: old reference
//    internal let finTransactionManager: FIRFinTransactionManagerProtocol =
//        FIRFinTransactionManager.shared

    /// Creates transaction in FireStore date base,
    /// creates transaction with capital account to define initial account amount,
    /// and updates capital account
    ///
    /// - Parameters:
    ///   - name: account name
    ///   - type: account type
    ///   - amount: initial monetary account amount
    ///   - completion: action to perform after function finishes execution,
    ///     for now it only works for successes
    internal func createAccount(
        _ name: String?,
        ofType type: AccountType?,
        completion: ((String?) -> Void)?
        ) {
        guard let name = name,
            let type = type,
            let newAccountRef = self.ref?.collection(DataObjectType.account.rawValue).document() else {
                return
        }
        newAccountRef.setData(
            [Account.fields.name: name,
             Account.fields.type: type.rawValue],
            completion: fireStoreCompletion)
    }

    /// Updates account name or / and current value.
    /// Current value is updated by creating transaction with capital account
    ///
    /// - Parameters:
    ///   - id: id of account to be updated
    ///   - name: new account name if needed
    ///   - amount: new account amount if needed
    ///   - completion: action to perform after function finishes execution,
    ///     for now it only works for successes
    internal func updateAccount(
        withId id: String?,
        name: String? = nil,
        amount: Int? = nil,
        completion: (() -> Void)? = nil
        ) {
    }

    internal func loadAll(_ completion: (([AccountId: Account]) -> Void)? = nil) {
        var accounts = [AccountId: Account]()
        self.ref?.collection(DataObjectType.account.rawValue).getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
                completion?(accounts)
            } else {
                for document in querySnapshot!.documents {
                    var acc = Account(document.data())
                    acc.id = document.documentID
                    accounts[document.documentID] = acc
                    print("\(document.documentID) => \(document.data())")
                }
                completion?(accounts)
            }
        }
    }
}
