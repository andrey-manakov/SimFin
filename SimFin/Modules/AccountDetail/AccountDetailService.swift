import Foundation

internal final class AccountDetailService: ClassService {
    func saveAccount(id: String?  = nil, name: String? = nil, type: AccountType? = nil) {
        guard let name = name, let type = type else {
            return
        }
        if let id = id {
            data.updateAccount(id: id, name: name)
        } else {
            _ = data.addAccount(name, type: type)
        }
    }
}
