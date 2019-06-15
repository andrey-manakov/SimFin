import UIKit

protocol RuleDetailDataSourceProtocol {
    var ruleItems: [RuleItem] { get set }
    var ruleItemsDesc: [RuleItem: String?] { get set }
    //    var rule: Rule? { get set }
    var actionOnAmountUpdate: ((Int) -> Void)? { get set }
    var actionOnDateBeginUpdate: ((Date) -> Void)? { get set }
    var actionOnDateEndUpdate: ((Date) -> Void)? { get set }

    func setAmountTextFieldFirstResponder()
    func resignAmountTextFieldFirstResponder()
}

class RuleDetailDataSource: NSObject, UITableViewDataSource, RuleDetailDataSourceProtocol {
    var ruleItems = [RuleItem]()
    var ruleItemsDesc = [RuleItem: String?]()
    //    var rule: Rule?
    private var amountTextField: TextFieldProtocol = SimpleTextField()
    private var descTextField: TextFieldProtocol?
    var actionOnAmountUpdate: ((Int) -> Void)?
    var actionOnDateBeginUpdate: ((Date) -> Void)?
    var actionOnDateEndUpdate: ((Date) -> Void)?

    deinit {
        print("\(type(of: self)) deinit")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ruleItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch ruleItems[indexPath.row] {
        case .from, .to, .dateBegin, .dateEnd, .dateLastExecution, .ratio, .baseAccount, .repeatMode:
            cell = leftRightCell(tableView, at: indexPath)

        case .amount:
            cell = inputAmountCell(tableView, at: indexPath)

        case .description:
            cell = inputTextCell(tableView, at: indexPath)

        case .dateBeginSelection, .dateEndSelection:
            cell = dateSelectionCell(tableView, at: indexPath)
        }
        return cell
    }

    private func leftRightCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell: LeftRightCellProtocol =
            tableView.dequeueReusableCell(
                withIdentifier: LeftRightCell.self.description()) as? LeftRightCell else {
                    return UITableViewCell()
        }
        let ruleItem = ruleItems[indexPath.row]
        cell.textLabel?.text = ruleItem.rawValue
        cell.detailTextLabel?.text = ruleItemsDesc[ruleItem] ?? ""
        cell.detailTextLabel?.textColor = .red
        return cell as? UITableViewCell ?? UITableViewCell()
    }

    private func inputTextCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell: InputTextCellProtocol =
            tableView.dequeueReusableCell(
                withIdentifier: InputTextCell.self.description()) as? InputTextCell else {
                    return UITableViewCell()
        }
        let ruleItem = ruleItems[indexPath.row]
        cell.textLabel?.text = ruleItem.rawValue
        descTextField = cell.textField
        cell.textField.delegate = self
        descTextField?.text = ruleItemsDesc[ruleItem] ?? ""
        return cell as? UITableViewCell ?? UITableViewCell()
    }

    private func inputAmountCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell: InputAmountCellProtocol =
            tableView.dequeueReusableCell(
                withIdentifier: InputAmountCell.self.description()) as? InputAmountCell else {
                    return UITableViewCell()
        }
        let ruleItem = ruleItems[indexPath.row]
        cell.textLabel?.text = ruleItem.rawValue
        amountTextField = cell.amountTextField
        cell.amountTextField.delegate = self
        amountTextField.text = ruleItemsDesc[ruleItem] ?? ""
        return cell as? UITableViewCell ?? UITableViewCell()
    }

    private func dateSelectionCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard var cell: DateSelectionCellProtocol =
            tableView.dequeueReusableCell(
                withIdentifier: DateSelectionCell.self.description()) as? DateSelectionCell else {
                    return UITableViewCell()
        }
        let ruleItem = ruleItems[indexPath.row]
        switch ruleItem {
        case .dateBeginSelection:
            cell.date = ((ruleItemsDesc[.dateBegin] ?? "") ?? "").date
            cell.actionOnDateChange = actionOnDateBeginUpdate

        case .dateEndSelection:
            cell.date = ((ruleItemsDesc[.dateEnd] ?? "") ?? "").date
            cell.actionOnDateChange = actionOnDateEndUpdate

        default:
            break
        }

//        if let item = getTransactionItem(at: indexPath) {
//            cell.actionOnDateChange = {[unowned self] date in
//                self.service.didChoose(transactionItem: item, with: date)
//            }
//        }

        return cell as? UITableViewCell ?? UITableViewCell()
    }

    func setAmountTextFieldFirstResponder() {
        _ = amountTextField.becomeFirstResponder()
    }

    func resignAmountTextFieldFirstResponder() {
        _ = amountTextField.resignFirstResponder()
    }
}

extension RuleDetailDataSource: UITextFieldDelegate {
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "0" {
            textField.text = ""
        }
    }
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing")
        actionOnAmountUpdate?(Int(textField.text ?? "") ?? 0)
    }
}
