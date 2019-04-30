import UIKit
/// Parent to all "service" classes which accompany View Controllers
internal class ClassService {
    // MARK: - Properties
    /// Reference to Data Singleton - the single entry point for all data requests
    internal let data: DataProtocol
    /// Unique id of instance
    internal var id: ObjectIdentifier { return ObjectIdentifier(self) }
    // MARK: - Initializers
    /// Initializes instance with Data Singleton
    ///
    /// Parameter _: Data Singleton or Data mock-up instance for testing
    internal init(_ data: DataProtocol = Data.shared) {
        self.data = data
    }
    /// Prints info about deinit for debug purposes and remove listners to data base
    deinit {
        /// Check that View Controller is deallocated - for debug purposes
        print("\(type(of: self)) deinit")
    }
}
