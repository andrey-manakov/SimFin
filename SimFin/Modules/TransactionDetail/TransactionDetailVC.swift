import UIKit

internal final class TransactionDetailVC: ViewController {
    /// Array of transaction detail items
    internal var service = TransactionDetailService()
    internal var transactionItems: [TransactionItem] = [.amount, .from, .to, .description]
    internal var transaction: FinTransaction?
    internal var transactionItemsDesc: [TransactionItem: String?] {
        let sequence = self.transactionItems.map { ($0, self.service.getTransactionData(transaction: self.transaction ?? FinTransaction(), item: $0)) }
        return Dictionary(uniqueKeysWithValues: sequence)
    }
    /// Table with interface elements
    internal var dataSource: TransactionDetailDataSourceProtocol? = TransactionDetailDataSource()
    private lazy var table: TransactionDetailTableViewProtocol = TransactionDetailTableView(dataSource, self)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transaction Details"
        dataSource?.actionOnAmountUpdate = { [unowned self] amount in
            self.transaction?.amount = amount
            self.reload()
        }
        let doneAction: (() -> Void)?
        if let data = self.data as? (id: FinTransactionId?, doneAction: (() -> Void)?) {
            doneAction = data.doneAction
            if let id = data.id {
                self.transaction = service.getFinTrasnsaction(withId: id)
            }
        } else {
            doneAction = nil
        }
        if self.transaction == nil {
            self.transaction = FinTransaction()
        }
        view.add(view: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
        navigationItem.rightBarButtonItem = BarButtonItem("Done") { [unowned self, service] in
            self.dataSource?.resignAmountTextFieldFirstResponder()
            _ = service.save(self.transaction)
            doneAction?()
            self.dismiss()
        }
        reload()
    }

    override func reload() {
        super.reload()
        dataSource?.transactionItems = transactionItems
        dataSource?.transactionItmesDesc = transactionItemsDesc
        table.reloadData()
    }
}
