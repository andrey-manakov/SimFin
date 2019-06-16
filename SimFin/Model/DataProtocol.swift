import Foundation
// TODO: unify implementation
internal protocol DataProtocol {
    var accounts: [AccountId: Account] { get }
    var transactions: [FinTransactionId: FinTransaction] { get }
    var rules: [RuleId: Rule] { get }

    // MARK: add data objects
    func add(_ account: Account, completion: ((Error?, AccountId?) -> Void)?)
    func add(transaction: FinTransaction) -> FinTransactionId?
    func add(_ rule: Rule, completion: ((Error?, RuleId?) -> Void)?)

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
