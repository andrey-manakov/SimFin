import UIKit

protocol TransactionDetailDelegateProtocol {
    var transactionItems: [TransactionItem] { get set }
    var transaction: Transaction? { get set }
}

internal final class TransactionDetailDelegate: NSObject, UITableViewDelegate, TransactionDetailDelegateProtocol {
    internal var transactionItems = [TransactionItem]()
    internal var transaction: Transaction?

    deinit {
        print("\(type(of: self)) deinit")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch transactionItems[indexPath.row] {
        case .amount:
            break

        case .from:
            break

        case .to:
            break

        case .description:
            break
        }
    }
}
