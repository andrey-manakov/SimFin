import UIKit

internal final class TransactionListVC: ViewController {
    let service = TransactionListService()
    var table: TransactionTableViewProtocol = TransactionsTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transaction List"
        navigationItem.rightBarButtonItem = BarButtonItem(.add) { [unowned self] in
            let doneAction = {
                self.reload()
            }
            self.push(TransactionDetailVC(doneAction))
        }
        reload()
        view.add(view: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
    }
    func reload() {
        table.localData = service.getData()
        table.reloadData()
    }
}
