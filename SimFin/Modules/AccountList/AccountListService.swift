class AccountListService: ClassService {
    func getData(forAccountType accountType: AccountType) -> DataModelProtocol {
        let rows = data.getAccounts(ofType: accountType).map {
            DataModelRow(id: $0.id, texts: [.name: $0.name ?? "", .desc: "\($0.amount ?? 0)"])
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
