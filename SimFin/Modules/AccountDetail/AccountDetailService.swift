import Foundation

internal final class AccountDetailService: ClassService {
    func saveAccount(id: String?  = nil, name: String? = nil, type: AccountType? = nil) {
        guard let name = name, let type = type else {
            return
        }
        if let id = id {
            //          FIXME: implementation needed
            print(id)
        } else {
            data.add(Account(id: nil, name: name, type: type, amount: 0)) { err, accountId in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    print("LOG message from AccountDetailService: Account with id \(accountId ?? "NIL") was created")
                }
            }
        }
    }
}
