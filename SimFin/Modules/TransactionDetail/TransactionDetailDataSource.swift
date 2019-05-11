import UIKit

protocol TransactionDetailDataSourceProtocol {
    var transactionItems: [TransactionItem] { get set }
    var transactionItemsDesc: [TransactionItem: String?] { get set }
//    var transaction: Transaction? { get set }
    var actionOnAmountUpdate: ((Int) -> Void)? { get set }

    func setAmountTextFieldFirstResponder()
    func resignAmountTextFieldFirstResponder()
}

class TransactionDetailDataSource: NSObject, UITableViewDataSource, TransactionDetailDataSourceProtocol {
    var transactionItems = [TransactionItem]()
    var transactionItemsDesc = [TransactionItem: String?]()
//    var transaction: Transaction?
    private var amountTextField: TextFieldProtocol = SimpleTextField()
    private var descTextField: TextFieldProtocol?
    var actionOnAmountUpdate: ((Int) -> Void)?

    deinit {
        print("\(type(of: self)) deinit")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch transactionItems[indexPath.row] {
        case .from:
            cell = leftRightCell(tableView, at: indexPath)

        case .to:
            cell = leftRightCell(tableView, at: indexPath)

        case .amount:
            cell = inputAmountCell(tableView, at: indexPath)

        case .description:
            cell = inputTextCell(tableView, at: indexPath)
        }
        return cell
    }

    private func leftRightCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell: LeftRightCellProtocol =
            tableView.dequeueReusableCell(
                withIdentifier: LeftRightCell.self.description()) as? LeftRightCell else {
                    return UITableViewCell()
        }
        let transactionItem = transactionItems[indexPath.row]
        cell.textLabel?.text = transactionItem.rawValue
        cell.detailTextLabel?.text = transactionItemsDesc[transactionItem] ?? "" // getValue(of: transactionItems[indexPath.row])
        cell.detailTextLabel?.textColor = .red
        return cell as? UITableViewCell ?? UITableViewCell()
    }

    private func inputTextCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell: InputTextCellProtocol =
            tableView.dequeueReusableCell(
                withIdentifier: InputTextCell.self.description()) as? InputTextCell else {
                    return UITableViewCell()
        }
        let transactionItem = transactionItems[indexPath.row]
        cell.textLabel?.text = transactionItem.rawValue
        descTextField = cell.textField
        cell.textField.delegate = self
        descTextField?.text = transactionItemsDesc[transactionItem] ?? ""
        return cell as? UITableViewCell ?? UITableViewCell()
    }

    private func inputAmountCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell: InputAmountCellProtocol =
            tableView.dequeueReusableCell(
                withIdentifier: InputAmountCell.self.description()) as? InputAmountCell else {
                    return UITableViewCell()
        }
        let transactionItem = transactionItems[indexPath.row]
        cell.textLabel?.text = transactionItem.rawValue
        amountTextField = cell.amountTextField
        cell.amountTextField.delegate = self
        amountTextField.text = transactionItemsDesc[transactionItem] ?? ""
        return cell as? UITableViewCell ?? UITableViewCell()
    }

    func setAmountTextFieldFirstResponder() {
        _ = amountTextField.becomeFirstResponder()
    }

    func resignAmountTextFieldFirstResponder() {
        _ = amountTextField.resignFirstResponder()
    }

//    private func dateSelectionCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
//        guard var cell: DateSelectionCellProtocol =
//            tableView.dequeueReusableCell(
//                withIdentifier: DateSelectionCell.self.description()) as? DateSelectionCell else {
//                    return UITableViewCell()
//        }
//        cell.textLabel?.text = "sdasd" // transactionItems[indexPath.row].rawValue
//        cell.date = tableData[indexPath].texts[.desc]?.date
//        if let item = getTransactionItem(at: indexPath) {
//            cell.actionOnDateChange = {[unowned self] date in
//                self.service.didChoose(transactionItem: item, with: date)
//            }
//        }
//        return cell as? UITableViewCell ?? UITableViewCell()
//    }
}

extension TransactionDetailDataSource: UITextFieldDelegate {
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
