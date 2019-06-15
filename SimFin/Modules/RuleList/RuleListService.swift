import Foundation

/// Service class for `RuleListVC`
internal final class RuleListService: ClassService {
    func getData() -> DataModelProtocol {
        let rows = data.getRules().map { args -> DataModelRow in
            let (ruleId, rule) = args
            return DataModelRow(id: ruleId, texts: [
                .left: "\(rule.lastExecutionDate ?? Date())",
                .up: data.getAccountName(id: rule.from),
                .down: data.getAccountName(id: rule.to),
                .right: "\(rule.amount ?? 0)"])
        }
//        let rows = data.getRules().map {
//            DataModelRow(id: $0.id, texts: [
//                .left: "\($0.lastExecutionDate ?? Date())",
//                .up: data.getAccountName(id: $0.from),
//                .down: data.getAccountName(id: $0.to),
//                .right: "\($0.amount ?? 0)"])
//        }
        print(rows)
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
