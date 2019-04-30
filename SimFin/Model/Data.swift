import Foundation
/// Data is a singleton for all data operations,
/// it is called only by Services: childs from ClassService, and other Services in Services folder
internal class Data: DataProtocol {
    internal static var shared = Data()
    var accounts = [String: Account]()
    var transactions = [String: Transaction]()
    var id: String { return UUID().uuidString }

    private init() {}
}
