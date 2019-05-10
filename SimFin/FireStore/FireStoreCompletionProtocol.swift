internal protocol FireStoreCompletionProtocol {
    func fireStoreCompletion(result: Any?, error: Error?)
    func fireStoreCompletion(error: Error?)
}

extension FireStoreCompletionProtocol {
    /// Used as completion action for FireStore runTransaction
    ///
    /// - Parameters:
    ///   - result: expected input as ()->()
    ///   - error: error passed from Transaction
    internal func fireStoreCompletion(result: Any?, error: Error?) {
        if let error = error {
            print("Error in working with firebase: \(error.localizedDescription)")
        } else {
            guard let completionAction = result as? () -> Void else {
                return
            }
            completionAction()
        }
    }

    /// Used as completion action for FireStore runTransaction
    ///
    /// - Parameters:
    ///   - error: error passed from Transaction
    internal func fireStoreCompletion(error: Error?) {
        if let error = error {
            print("Error in working with firebase: \(error)")
        }
    }
}
