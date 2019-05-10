class AccountListService: ClassService {
    func getData() -> DataModelProtocol {
        let rows = data.getAccounts().map {
            DataModelRow(id: $0.id, texts: [.name: $0.name ?? "", .desc: "\($0.amount ?? 0)"])
        }
        return DataModel(rows)
    }
    func delete(row: DataModelRowProtocol?, completion: (() -> Void)? = nil) {
        guard let id = row?.id else {
            fatalError("Nil Id")
        }
        Data.shared.delete(accountWithId: id) {}
        completion?()
    }
}
