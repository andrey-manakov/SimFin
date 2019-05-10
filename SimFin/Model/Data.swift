import Foundation
/// Data is a singleton for all data operations,
/// it is called only by Services: childs from ClassService, and other Services in Services folder
internal class Data: DataProtocol {
    internal static var shared = Data()
    var accounts = [AccountId: Account]()
    var transactions = [FinTransactionId: FinTransaction]()
    var id: String { return UUID().uuidString }
    private let fireAuth: FireAuthProtocol? = FIRAuth.shared

    private init() {
        FIRAccountManager.shared.loadAll { accounts in
            self.accounts = accounts
            UIApplication.topViewController()?.reload()
        }
        FIRFinTransactionManager.shared.loadAll { transactions in
            self.transactions = transactions
            UIApplication.topViewController()?.reload()
        }
    }
}

// MARK: - Sign In, Sign Out
extension Data {
    internal func signOut(_ completion: ((Error?) -> Void)? = nil) {
        fireAuth?.signOutUser(completion)
    }

    internal func signInUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?) {
        fireAuth?.signInUser(withEmail: email, password: pwd, completion: completion)
    }

    internal func signUpUser(withEmail email: String, password pwd: String, completion: ((Error?) -> Void)?) {
        fireAuth?.createUser(withEmail: email, password: pwd, completion: completion)
    }

    internal func deleteUser(completion: ((Error?) -> Void)?) {
        fireAuth?.deleteUser(completion)
    }
}
