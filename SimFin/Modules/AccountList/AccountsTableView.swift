import UIKit

protocol AccountTableViewProtocol: TableViewProtocol {
    var localData: DataModelProtocol? { get set }

    func reloadData()
}

class AccountsTableView: TableView, AccountTableViewProtocol {
    override init() {
        super.init()
        register(AccountCell.self, forCellReuseIdentifier: AccountCell.self.description())
    }
    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
    override internal func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        guard let cell: AccountCellProtocol = dequeueReusableCell(
            withIdentifier: AccountCell.self.description()) as? AccountCell else {
                return UITableViewCell()
        }
        cell.textLabel?.text = "\((data[indexPath].texts[.name] ?? "") ?? "")"
        cell.detailTextLabel?.text = "\((data[indexPath].texts[.desc] ?? "") ?? "")"
        return cell as? AccountCell ?? UITableViewCell()
    }
}
