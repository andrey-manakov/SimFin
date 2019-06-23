/// View controller for sign in / sign up, is shown after app installed and launched for the first time
internal final class LoginVC: ViewController {
    /// /// Service of view controller to perform actions on data
    private let service = LoginService()
    /// Text field for login
    private let loginTextField: TextFieldProtocol = EmailField("email")
    /// Text field for password
    private let passwordTextField: TextFieldProtocol = PasswordField("password")
    /// Configures view controller after view is loaded
    override internal func viewDidLoad() {
        super.viewDidLoad()
        setListners()
        let signInButton: ButtonProtocol = Button(name: "Sign In", action: signIn)
        let signUpButton: ButtonProtocol = Button(name: "Sign Up", action: signUp)
        view.add(views:
            ["appTitle": AppTitle(),
             "loginTextField": loginTextField as? UIView,
             "passwordTextField": passwordTextField as? UIView,
             "signInButton": signInButton as? UIView,
             "signUpButton": signUpButton as? UIView], withConstraints:
            ["H:|-50-[appTitle]-50-|",
             "H:|-50-[loginTextField]-50-|",
             "H:|-50-[passwordTextField]-50-|",
             "H:|-100-[signInButton]-100-|",
             "H:|-100-[signUpButton]-100-|",
             "V:|-40-[appTitle(100)]-20-[loginTextField(44)]-20-[passwordTextField(44)]-30-[signInButton(44)]-20-[signUpButton(44)]"])
        _ = loginTextField.becomeFirstResponder()
    }
    /// Calls service to perform sign in
    private func signIn() {
        guard let login = self.loginTextField.text, let password = self.passwordTextField.text else {
            return
        }
        cleanTextFields()
        self.service.didTapSignIn(withLogin: login, andPassword: password) { error in
            if let error = error {
                self.alert(message: error.localizedDescription)
            }
        }
    }
    /// Calls service to perform sign up
    private func signUp() {
        guard let login = self.loginTextField.text, let password = self.passwordTextField.text else {
            return
        }
        cleanTextFields()
        self.service.didTapSignUp(
            withLogin: login,
            andPassword: password) { error in
                if let error = error {
                    self.alert(message: error.localizedDescription)
                }
        }
    }
    /// Calls Service to set listners to authorisation events, to trigger enter after database sends event of successful login
    private func setListners() {
        service.listenToAuthUpdates {[unowned self] user in
            if user != nil {
//                self.present(NavigationController(TransactionListVC()), animated: true)
                self.present(TabBarController.shared)
                self.service.loadData()
                // FIXME: Remove direct access to Data
                Data.shared.setListners()
            } else {
                print("User is nil")
            }
        }
    }
    /// Cleans login and password text fields
    private func cleanTextFields() {
        self.loginTextField.text = ""
        self.passwordTextField.text = ""
    }
}
