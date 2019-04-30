import UIKit

extension TransactionDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch transactionItems[indexPath.row] {
        case .amount:
            break

        case .from:
            let selectionAction: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void) = { [unowned self] row, ix in
                self.transaction?.from = row.id
                self.reload()
            }
            push(AccountListVC(selectionAction))

        case .to:
            let selectionAction: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void) = { [unowned self] row, ix in
                self.transaction?.to = row.id
                self.reload()
            }
            push(AccountListVC(selectionAction))

        case .description:
            break
        }
    }
}
