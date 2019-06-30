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

    deinit {
        print("\(type(of: self)) deinit")
    }
    enum Action {
        case create, delete//, loadAll
    }
}
