import Foundation
/// Data is a singleton for all data operations,
/// it is called only by Services: childs from ClassService, and other Services in Services folder
internal class Data: DataProtocol {
    internal static var shared = Data()
    var accounts = [AccountId: Account]()
    var transactions = [FinTransactionId: FinTransaction]()
    var rules = [RuleId: Rule]()
    var id: String { return UUID().uuidString }
    let fireAuth: FireAuthProtocol? = FIRAuth.shared

    private init() {}
}
