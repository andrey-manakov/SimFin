import UIKit

internal final class AccountListVC: ViewController {
    var table: AccountTableViewProtocol = AccountsTableView()
    private let service = Service()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Accounts"
        view.add(view: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
        if let data = data as? ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void) {
//            let action: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void) = { [unowned self] row, ix in
//                data(row, ix)
//                self.dismiss()
//            }
//            table.didSelect = action
            table.didSelect = { [unowned self] row, ix in
                data(row, ix)
                self.dismiss()
            }
        }

//        table.didSelect = data as? ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)
//        table.didSelect = { [unowned self] row: DataModelRowProtocol, ix: IndexPath in
//            let action = data as? (_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void
//            action(row, ix)
//            self.dismiss()
//        }
        navigationItem.rightBarButtonItem = BarButtonItem(.add) { [unowned self] in
            self.push(AccountDetailVC(self.reloadData))
        }
        reloadData()
    }

    func reloadData() {
        table.localData = service.getData()
        table.reloadData()
    }
}

extension AccountListVC {
    private class Service: ClassService {
        func getData() -> DataModelProtocol {
            let rows = data.getAccounts().map {
                DataModelRow(id: $0.id, texts: [.name: $0.name ?? "", .desc: "\($0.amount ?? 0)"])
            }
            return DataModel(rows)
        }
    }
}
