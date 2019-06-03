import UIKit

internal final class AccountListVC: ViewController {
    var table: AccountTableViewProtocol = AccountsTableView()
    private let service = AccountListService()
    let types = AccountType.allCases.map { $0.rawValue }
    lazy var segmentedControl: SegmentedControlProtocol = SegmentedControl(types) { _ in
        self.reload()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Accounts"

        view.add(view: segmentedControl as? UIView, withConstraints: ["H:|-30-[v]-30-|", "V:|-75-[v(30)]"])
        view.add(view: table as? UIView, withConstraints: ["H:|[v]|", "V:|-120-[v]|"])
        if let data = data as? ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void) {
            table.didSelect = { [unowned self] row, ix in
                data(row, ix)
                self.dismiss()
            }
        }
        table.swipeLeftLabel = "Delete"
        table.swipeLeftAction = { [unowned self] row in
            self.service.delete(row: row) {
                self.reload()
            }
        }
        navigationItem.rightBarButtonItem = BarButtonItem("Add") { [unowned self] in
            self.push(AccountDetailVC(self.reload))
        }
        reload()
    }

    override func reload() {
        super.reload()
        table.localData = service.getData(forAccountType: AccountType(rawValue: types[segmentedControl.selectedSegmentIndex]) ?? .asset)
//        table.filter = { row in return true }
        table.reloadData()
    }
}
