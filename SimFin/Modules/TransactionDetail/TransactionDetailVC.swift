import UIKit

internal final class TransactionDetailVC: ViewController {
    /// Array of transaction detail items
    internal var service = TransactionDetailService()
    internal var transactionItems: [TransactionItem] = [.amount, .from, .to, .description]
    internal var transaction: Transaction?
    internal var transactionItemsDesc: [TransactionItem: String?] {
        let sequence = self.transactionItems.map { ($0, self.service.getTransactionData(transaction: self.transaction ?? Transaction(), item: $0)) }
        return Dictionary(uniqueKeysWithValues: sequence)
    }
    /// Table with interface elements
    private var dataSource: TransactionDetailDataSourceProtocol? = TransactionDetailDataSource()
    private lazy var table: TransactionDetailTableViewProtocol = TransactionDetailTableView(dataSource, self)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transaction Details"
        dataSource?.actionOnAmountUpdate = { [unowned self] amount in
            self.transaction?.amount = amount
            self.reload()
        }
        transaction = data as? Transaction ?? Transaction()
        view.add(view: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
        navigationItem.rightBarButtonItem = BarButtonItem(.done) { [unowned self, service] in
            _ = service.save(self.transaction)
            if let doneAction = self.data as? () -> Void {
                doneAction()
            }
            self.dismiss()
        }
        reload()
        dataSource?.setAmountTextFieldFirstResponder()
    }

    func reload() {
        dataSource?.transactionItems = transactionItems
        dataSource?.transactionItmesDesc = transactionItemsDesc
        table.reloadData()
    }
}
