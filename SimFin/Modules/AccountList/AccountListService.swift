class AccountListService: ClassService {
    func getData(forAccountType accountType: AccountType) -> DataModelProtocol {
        let rows = data.accounts.map { args -> DataModelRow in
            let (accountId, account) = args
            return DataModelRow(id: accountId, texts: [.name: account.name ?? "", .desc: "\(account.amount ?? 0)"])
        }
        return DataModel(rows)
    }
    func delete(row: DataModelRowProtocol?, completion: (() -> Void)? = nil) {
        guard let id = row?.id else {
            fatalError("Nil Id")
        }
        Data.shared.delete(accountWithId: id) { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                print("LOG message from AccountListService: Account was deleted")
            }
        }
        completion?()
    }
}
