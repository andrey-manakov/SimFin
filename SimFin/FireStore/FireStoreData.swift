internal class FireStoreData: FIRDataProtocol {
    //    private let fa: FireAuthProtocol = FIRAuth.shared
    internal let fireDB = Firestore.firestore()
    internal var ref: DocumentReference? {
        guard let user = Auth.auth().currentUser?.uid else {
            return nil
        }
        return Firestore.firestore().document("users/\(user)")
    }
    //    lazy var data: DataProtocol = Data.shared

    /// Singleton variable
    internal static var shared: FIRDataProtocol = FireStoreData()

    private let capitalAccountName = "capital"
    internal var capitalDoc: DocumentReference? {
        return ref?.collection(DataObjectType.account.rawValue).document(capitalAccountName)
    }

    private init() {
        // MARK: - With this change, timestamps in Cloud Firestore will be read as Firebase Timestamp objects
        // instead of as system Date objects.
        // So you will also need to update code expecting a Date to instead expect a Timestamp. For example:
        //        // old:
        //        let date: Date = documentSnapshot.get("created_at") as! Date
        //        // new:
        //        let timestamp: Timestamp = documentSnapshot.get("created_at") as! Timestamp
        //        let date: Date = timestamp.dateValue()

        //        let db = Firestore.firestore()
        //        let settings = db.settings
        //        settings.areTimestampsInSnapshotsEnabled = true
        //        settings.isPersistenceEnabled = false
        //        db.settings = settings

        // FIXME: Need to check capital account also when user signs in
        //        checkIfCapitalAccountExist()
    }
}

extension FireStoreData: FireStoreGettersProtocol, FireStoreCompletionProtocol {}
