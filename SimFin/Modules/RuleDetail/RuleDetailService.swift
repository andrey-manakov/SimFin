import Foundation

internal class RuleDetailService: ClassService {
    func save(_ rule: Rule?) {
        guard let rule = rule else {
            return
        }
        data.save(rule) { [unowned self] err, ruleId in
            if let err = err {
                print(err.localizedDescription)
            } else {
                if let ruleId = ruleId {
                    print("LOG message from RuleDetailService: rule with id \(ruleId) saved")
                }
            }
        }
    }

    func getRuleData(rule: Rule, item: RuleItem) -> String? {
        switch item {
        case .from:
            guard let from = rule.from else {
                return nil
            }
            return data.getAccountName(id: from)

        case .to:
            guard let to = rule.to else {
                return nil
            }
            return data.getAccountName(id: to)

        case .amount:
            return "\(rule.amount ?? 0)"

        case .description:
            return rule.description ?? ""

        case .ratio:
            return "\(rule.amount ?? 0)"

        case .baseAccount:
            return data.getAccountName(id: rule.baseAccount)

        case .dateBegin:
            return (rule.beginDate ?? Date()).string

        case .dateEnd:
            return (rule.endDate ?? Date()).string

        case .dateLastExecution:
            return "\(rule.lastExecutionDate ?? Date())"

        case .repeatMode:
            return "\(rule.repeatMode ?? .monthly)"

        case .dateBeginSelection, .dateEndSelection:
            return nil
        }
    }

    func getRule(withId id: RuleId) -> Rule? {
        return Data.shared.rules[id]
    }
}
