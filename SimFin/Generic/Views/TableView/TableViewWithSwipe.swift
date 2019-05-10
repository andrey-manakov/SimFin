import UIKit

internal protocol TableViewWithSwipeProtocol: TableViewProtocol {
    var swipeLeftLabel: String? { get set }
    var swipeRightLabel: String? { get set }
    var swipeLeftAction: ((_ row: DataModelRowProtocol?) -> Void)? { get set }
    var swipeRightAction: ((_ row: DataModelRowProtocol?) -> Void)? { get set }
}

internal class TableViewWithSwipe: TableView, TableViewWithSwipeProtocol {
    internal var swipeLeftLabel: String?
    internal var swipeRightLabel: String?
    internal var swipeLeftAction: ((_ row: DataModelRowProtocol?) -> Void)?
    internal var swipeRightAction: ((_ row: DataModelRowProtocol?) -> Void)?

    internal func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath
        ) -> UISwipeActionsConfiguration? {
        let handler = {[unowned self] (_:UIContextualAction, _:UIView, success: (Bool) -> Void) in
            self.swipeRightAction?(self.data[indexPath])
            success(true)
        }
        let rightSwipe = UIContextualAction(style: .normal, title: swipeRightLabel ?? "", handler: handler)
        rightSwipe.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [rightSwipe])
    }

    internal func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath
        ) -> UISwipeActionsConfiguration? {
        let handler = {(_:UIContextualAction, _:UIView, success: (Bool) -> Void) in
            self.swipeLeftAction?(self.data[indexPath])
            success(true)
        }
        let leftSwipe = UIContextualAction(style: .normal, title: swipeLeftLabel ?? "", handler: handler)
        leftSwipe.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [leftSwipe])
    }
}
