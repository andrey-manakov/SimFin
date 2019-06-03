import UIKit

internal final class AccountDetailVC: ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account Details"
        let service = AccountDetailService()
        let types = AccountType.allCases.map { $0.rawValue }
        let segmentedControl: SegmentedControlProtocol = SegmentedControl(types) { ix in
            print(ix)
        }
        let accountNameTextField: TextFieldProtocol = SimpleTextField("Account Name") { [unowned self, service] text in
            if let accountName = text {
                service.saveAccount(id: nil, name: accountName, type: AccountType(rawValue: types[segmentedControl.selectedSegmentIndex]))
                print(Data.shared.accounts)
            }
            self.dismiss()
            if let doneAction = self.data as? () -> Void {
                doneAction()
            }
        }
        navigationItem.rightBarButtonItem = BarButtonItem("Done") { [unowned self, service] in
            if let accountName = accountNameTextField.text {
                service.saveAccount(id: nil, name: accountName, type: AccountType(rawValue: types[segmentedControl.selectedSegmentIndex]))
            }
            self.dismiss()
            if let doneAction = self.data as? () -> Void {
                doneAction()
            }
        }
        view.add(view: segmentedControl as? UIView, withConstraints: ["H:|-30-[v]-30-|", "V:|-80-[v(30)]"])
        view.add(view: accountNameTextField as? UIView, withConstraints: ["H:|-30-[v]-30-|", "V:|-130-[v(30)]"])
        _ = accountNameTextField.becomeFirstResponder()
    }
}
