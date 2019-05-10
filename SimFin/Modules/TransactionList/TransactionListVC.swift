import UIKit

internal final class TransactionListVC: ViewController {
    let service = TransactionListService()
    var table: TransactionTableViewProtocol = TransactionsTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transaction List"
        navigationItem.rightBarButtonItem = BarButtonItem("Add") { [unowned self] in
            let doneAction = {
                self.reload()
            }
            self.push(TransactionDetailVC(doneAction))
        }
        reload()
        table.swipeLeftLabel = "Delete"
        table.swipeLeftAction = { [unowned self] row in
            self.service.delete(row: row) {
                self.reload()
            }
        }
        table.didSelect = { [unowned self] row, ix in
            let doneAction = {
                self.reload()
            }
            self.push(TransactionDetailVC((row.id, doneAction)))
        }

        view.add(view: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    override func reload() {
        super.reload()
        table.localData = service.getData()
        table.reloadData()
    }
}
