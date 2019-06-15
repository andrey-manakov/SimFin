import Foundation

internal protocol DataProtocol {
    // MARK: add data objects
    // TODO: unify implementation
    func addAccount(_ name: String, type: AccountType) -> AccountId
    func add(transaction: FinTransaction) -> FinTransactionId?

    // MARK: extraction all methods
    func getAccounts() -> [Account]
    func getTransactions() -> [FinTransaction]
    func getRules() -> [RuleId: Rule]

    // MARK: subset extraction
    func getAccounts(ofType type: AccountType) -> [Account]
    func getAccountName(id: AccountId?) -> String?

    // MARK: update methods
    func updateAccount(id: String, name: String)
    func save(transaction: FinTransaction, completion: ((Error?) -> Void)?)
    func save(_ rule: Rule, completion: ((Error?, RuleId?) -> Void)?)

    // MARK: delete methods
    func delete(transactionWithId id: String, completion: ((Error?) -> Void)?)
    func delete(accountWithId id: String, completion: ((Error?) -> Void)?)

    // MARK: authorization methods
    func signOut(_ completion: ((Error?) -> Void)?)
    func signInUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?)
    func signUpUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?)
}

extension DataProtocol {
    func save(transaction: FinTransaction) {
        save(transaction: transaction, completion: nil)
    }
}
