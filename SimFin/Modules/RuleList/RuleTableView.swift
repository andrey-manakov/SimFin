import UIKit

protocol RuleTableViewProtocol: TableViewWithSwipeProtocol {
    //    var localData: DataModelProtocol? { get set }
    //    var swipeLeftLabel: String? { get set }
    //    var swipeRightLabel: String? { get set }
    //    var swipeLeftAction: ((_ row: DataModelRowProtocol?) -> Void)? { get set }
    //    var swipeRightAction: ((_ row: DataModelRowProtocol?) -> Void)? { get set }
}

class RuleTableView: TableViewWithSwipe, RuleTableViewProtocol {
    override init() {
        super.init()
        register(RuleCell.self, forCellReuseIdentifier: RuleCell.self.description())
    }
    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
    override internal func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        guard let cell: RuleCellProtocol = dequeueReusableCell(
            withIdentifier: RuleCell.self.description()) as? RuleCell else {
                return UITableViewCell()
        }
        cell.date.text = "\((data[indexPath].texts[.left] ?? "") ?? "")"
        cell.from.text = "from: \((data[indexPath].texts[.up] ?? "") ?? "")"
        cell.to.text = "to: \((data[indexPath].texts[.down] ?? "") ?? "")"
        cell.amount.text = data[indexPath].texts[.right]  ?? ""
        cell.accessibilityIdentifier = "cell_\(indexPath.row)"
        return cell as? RuleCell ?? UITableViewCell()
    }
}
