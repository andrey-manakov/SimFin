import Foundation

internal protocol DataProtocol {
    func addAccount(_ name: String, type: AccountType) -> AccountId
    func updateAccount(id: String, name: String)
    func getAccounts() -> [Account]
    func getAccountName(id: AccountId?) -> String?
    func add(transaction: Transaction) -> TransactionId
    func getTransactions() -> [Transaction]
}
