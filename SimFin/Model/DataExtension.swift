import Foundation

extension Data {
    func addAccount(_ name: String, type: AccountType) -> AccountId {
        let id = self.id
        accounts[id] = Account(id: id, name: name, type: type, amount: 0)
        return id
    }
    func updateAccount(id: String, name: String) {
        print("implementation is needed")
    }
    func getAccounts() -> [Account] {
        return Array(accounts.values)
    }
    func getAccountName(id: AccountId?) -> String? {
        guard let id = id else {
            return nil
        }
        return accounts[id]?.name
    }
    func add(transaction: Transaction) -> TransactionId {
        let id = self.id
        transactions[id] = Transaction(id: id, from: transaction.from, to: transaction.to, amount: transaction.amount, description: transaction.description, date: transaction.date ?? Date())
        return id
    }
    func getTransactions() -> [Transaction] {
        return Array(transactions.values)
    }
}
