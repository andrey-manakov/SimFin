import UIKit

internal final class AccountDetailVC: ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let service = AccountDetailService()
        let accountNameTextField: TextFieldProtocol = SimpleTextField("Account Name") {[unowned self] in
            _ = self
            print("action on return")
        }
//        print(Array(AccountType.allCases).map {$0.rawValue})
        let types = AccountType.allCases.map { $0.rawValue }
        let segmentedControl: SegmentedControlProtocol = SegmentedControl(types) { ix in
            print(ix)
        }
//        For some reason doesn't work, when keyboard is open!
//        navigationItem.rightBarButtonItem = BarButtonItem(.done) { [unowned self, service] in
//            if let accountName = accountNameTextField.text {
//                service.saveAccount(id: nil, name: accountName)
//                print(Data.shared.accounts)
//            }
//            self.dismiss()
//        }
        let doneButton: ButtonProtocol = Button(name: "Done") {[unowned self] in
            if let accountName = accountNameTextField.text {
                service.saveAccount(id: nil, name: accountName, type: AccountType(rawValue: types[segmentedControl.selectedSegmentIndex]))
                print(Data.shared.accounts)
            }
            self.dismiss()
            if let doneAction = self.data as? () -> Void {
                doneAction()
            }
        }
        view.add(view: segmentedControl as? UIView, withConstraints: ["H:|-30-[v]-30-|", "V:|-150-[v(30)]"])
        view.add(view: accountNameTextField as? UIView, withConstraints: ["H:|-30-[v]-30-|", "V:|-200-[v(30)]"])
        view.add(view: doneButton as? UIView, withConstraints: ["H:|-40-[v]-40-|", "V:|-300-[v(50)]"])
    }
}
