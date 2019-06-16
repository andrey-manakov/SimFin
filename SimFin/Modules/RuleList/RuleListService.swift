import Foundation

/// Service class for `RuleListVC`
internal final class RuleListService: ClassService {
    func getData() -> DataModelProtocol {
        let rows = data.rules.map { args -> DataModelRow in
            let (ruleId, rule) = args
            return DataModelRow(id: ruleId, texts: [
                .left: "\(rule.lastExecutionDate ?? Date())",
                .up: data.accounts[rule.from ?? ""]?.name, // data.getAccountName(id: rule.from),
                .down: data.accounts[rule.from ?? ""]?.name, // data.getAccountName(id: rule.to),
                .right: "\(rule.amount ?? 0)"])
        }
        return DataModel(rows)
    }

    func delete(row: DataModelRowProtocol?, completion: ((Error?) -> Void)? = nil) {
        guard let id = row?.id else {
            fatalError("Nil Id")
        }
        Data.shared.delete(transactionWithId: id, completion: completion)
    }

    func logOut(completion: ((Error?) -> Void)? = nil) {
        data.signOut(completion)
    }
}
