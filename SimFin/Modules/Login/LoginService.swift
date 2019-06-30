import Foundation
/// Service class for `LoginVC`
internal final class LoginService: ClassService {
    /// Sets listners to authorisation events, to trigger enter after database sends event of successful login
    ///
    /// - Parameter action: perform action after successfuk login
    func listenToAuthUpdates(withAction action: ((String?) -> Void)?) {
        // TODO: don't call Firebase directly
        FIRAuth.shared.getUpdatedUserInfo[ObjectIdentifier(self)] = action
    }

    /// Performs sign in
    ///
    /// - Parameters:
    ///   - login: login value
    ///   - password: password value
    ///   - completion: action to perform after sign in
    func didTapSignIn(
        withLogin login: String?,
        andPassword password: String?,
        completion: ((Error?) -> Void)? = nil
        ) {
        guard let lgn = login, let pwd = password else {
            return
        }
        // FIXME: change implementation
        let newCompletion: ((Error?) -> Void) = { err in
            completion?(err)
            FIRAccountManager.shared.loadAll { accounts in
                Data.shared.accounts = accounts
                UIApplication.topViewController()?.reload()
            }
//            FIRFinTransactionManager.shared.loadAll { transactions in
//                Data.shared.transactions = transactions
//                UIApplication.topViewController()?.reload()
//            }
        }
        Data.shared.signInUser(withEmail: lgn, password: pwd, completion: newCompletion)
    }

    /// Performs sign up
    ///
    /// - Parameters:
    ///   - login: login value
    ///   - password: password value
    ///   - completion: action to perform after sign up
    internal func didTapSignUp(
        withLogin login: String?,
        andPassword password: String?,
        completion: ((Error?) -> Void)? = nil
        ) {
        guard let lgn = login, let pwd = password else {
            return
        } // TODO: consider use UIAlertVC
        // FIXME: change implementation
        let newCompletion: ((Error?) -> Void) = { err in
            completion?(err)
            self.loadData()
        }
        Data.shared.signUpUser(withEmail: lgn, password: pwd, completion: newCompletion)
    }

    internal func loadData(completion: ((Error?) -> Void)? = nil) {
        FIRAccountManager.shared.loadAll { accounts in
            Data.shared.accounts = accounts
            UIApplication.topViewController()?.reload()
        }
//        FIRFinTransactionManager.shared.loadAll { transactions in
//            Data.shared.transactions = transactions
//            UIApplication.topViewController()?.reload()
//        }
    }
}
