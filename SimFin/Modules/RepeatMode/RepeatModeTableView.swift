import UIKit

protocol RepeatModeTableViewProtocol: TableViewProtocol {
}

class RepeatModeTableView: TableView, RepeatModeTableViewProtocol {
    override init() {
        super.init()
        register(LeftRightCell.self, forCellReuseIdentifier: LeftRightCell.self.description())
    }
    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
    override internal func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        guard let cell: LeftRightCellProtocol = dequeueReusableCell(
            withIdentifier: LeftRightCell.self.description()) as? LeftRightCell else {
                return UITableViewCell()
        }
        cell.textLabel?.text = "\((data[indexPath].id ?? ""))"
        if let accessoryRawValue = data[indexPath].accessory {
            cell.accessoryType = UITableViewCell.AccessoryType(rawValue: accessoryRawValue) ?? .none
        }
        cell.textLabel?.accessibilityIdentifier = cell.textLabel?.text

//        cell.date.text = "\((data[indexPath].texts[.left] ?? "") ?? "")"
//        cell.from.text = "from: \((data[indexPath].texts[.up] ?? "") ?? "")"
//        cell.to.text = "to: \((data[indexPath].texts[.down] ?? "") ?? "")"
//        cell.amount.text = data[indexPath].texts[.right]  ?? ""
//        cell.accessibilityIdentifier = "cell_\(indexPath.row)"
        return cell as? LeftRightCell ?? UITableViewCell()
    }
}
