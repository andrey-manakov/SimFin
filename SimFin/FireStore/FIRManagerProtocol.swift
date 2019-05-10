internal final class FIRManagerProtocol {
}

internal class FIRManager {
    internal let fireDB = Firestore.firestore()
    internal var ref: DocumentReference? {
        guard let user = FIRAuth.shared.currentUserUid else {
            return nil
        }
        return Firestore.firestore().document("users/\(user)")
    }
    internal let capitalAccountName = "capital"
    internal var capitalDoc: DocumentReference? {
        return ref?.collection(DataObjectType.account.rawValue).document(capitalAccountName)
    }
}
