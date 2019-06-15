import UIKit

extension RuleDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch ruleItems[indexPath.row] {
        case .dateBeginSelection, .dateEndSelection:
            return 150

        default:
            return 44
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        ruleItems = [.amount, .from, .to, .dateBegin, .dateEnd, .repeatMode]
        switch ruleItems[indexPath.row] {
        case .amount:
            break

        case .from:
            let selectionAction: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void) = { [unowned self] row, ix in
                self.rule?.from = row.id
                self.reload()
            }
            push(AccountListVC(selectionAction))

        case .to:
            let selectionAction: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void) = { [unowned self] row, ix in
                self.rule?.to = row.id
                self.reload()
            }
            push(AccountListVC(selectionAction))

        case .description:
            break

        case .ratio:
            break

        case .baseAccount:
            break

        case .dateBegin:
            ruleItems = [.amount, .from, .to, .dateBegin, .dateBeginSelection, .dateEnd, .repeatMode]
            reload()

        case .dateEnd:
            ruleItems = [.amount, .from, .to, .dateBegin, .dateEnd, .dateEndSelection, .repeatMode]
            reload()

        case .dateLastExecution:
            break

        case .repeatMode:
            let selectionAction: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void) = { [unowned self] row, ix in
                guard let id = row.id, let repeatMode = RepeatMode(rawValue: id) else {
                    return
                }
                self.rule?.repeatMode = repeatMode
                self.reload()
            }
            push(RepeatModeVC((rule?.repeatMode, selectionAction)))

        case .dateBeginSelection:
            break

        case .dateEndSelection:
            break
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch ruleItems[indexPath.row] {
        case .amount:
            dataSource?.setAmountTextFieldFirstResponder()

        default:
            break
        }
    }
}
