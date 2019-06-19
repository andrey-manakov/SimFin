import UIKit

internal final class RuleListVC: ViewController {
    let service = RuleListService()
    var table: RuleTableViewProtocol = RuleTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rules"
        navigationItem.leftBarButtonItem = BarButtonItem("Log Out") { [unowned self] in
            self.service.logOut { [unowned self] err in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    self.dismiss(animated: true) {}
                }
            }
        }
        navigationItem.rightBarButtonItem = BarButtonItem("Add") { [unowned self] in
            let doneAction = {
                self.reload()
            }
            let input: (ruleId: RuleId?, doneAction: (() -> Void)?) = (ruleId: nil, doneAction: doneAction)
            self.push(RuleDetailVC(input))
        }
        reload()
        table.swipeLeftLabel = "Delete"
        table.swipeLeftAction = { [unowned self] row in
            self.service.delete(row: row) { err in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    print("LOG message from \(type(of: self)): Rule was deleted")
                    self.reload()
                }
            }
        }
        table.didSelect = { [unowned self] row, ix in
            let doneAction = {
                self.reload()
            }
            print(row)
//            let inputData: (ruleId: RuleId?, doneAction: (() -> Void)?) = (row.id, doneAction)
            self.push(RuleDetailVC((row.id, doneAction)))
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
