import Foundation

internal protocol DataProtocol {
    func addAccount(_ name: String, type: AccountType) -> AccountId
    func updateAccount(id: String, name: String)
    func getAccounts() -> [Account]
    func getAccountName(id: AccountId?) -> String?
    func save(transaction: FinTransaction, completion: (() -> Void)?)
    func add(transaction: FinTransaction) -> FinTransactionId?
    func delete(transactionWithId id: String, completion: (() -> Void)?)
    func delete(accountWithId id: String, completion: (() -> Void)?)
    func getTransactions() -> [FinTransaction]
    func signOut(_ completion: ((Error?) -> Void)?)
    func signInUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?)
    func signUpUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?)
}

extension DataProtocol {
    func save(transaction: FinTransaction) {
        save(transaction: transaction, completion: nil)
    }
}
