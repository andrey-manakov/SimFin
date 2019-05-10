// MARK: - Simple create, update, delete oprations on FireStore DataBase
extension FireStoreData {
    /// Creates data object in FireStore DataBase
    ///
    /// - Parameters:
    ///   - dataObject: collection reference (Accounts, Transactions, etc.)
    ///   - data: data for data object creation
    ///   - completion: function to run after the action performed with new data object id as a parameter
    internal func create(
        _ dataObject: DataObjectType,
        with data: [String: Any?],
        completion: ((String?) -> Void)? = nil
        ) {
        var docRef: DocumentReference?
        docRef = ref?.collection(dataObject.rawValue).addDocument(data: data as [String: Any]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                completion?(docRef?.documentID)
            }
        }
    }

    /// Updates the data object without overwriting the whole document
    ///
    /// - Parameters:
    ///   - dataObject: collection reference (Accounts, Transactions, etc.)
    ///   - id: id of the data object to update
    ///   - values: dictionary with fields and new values to update
    ///   - completion: function to run after successful update
    internal func update(
        _ dataObject: DataObjectType,
        id: String?,
        with values: [String: Any?],
        completion: (() -> Void)? = nil
        ) {
        guard let id = id else {
            return
        }
        ref?.collection(dataObject.rawValue).document(id).updateData(values as [AnyHashable: Any]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                completion?()
            }
        }
    }
}

// MARK: - Capital Account Creation if needed
extension FireStoreData {
    /// Creates Capital account if doesn't exist
    internal func checkIfCapitalAccountExist(completion: ((Error?) -> Void)? = nil) {
        // FIXME: get rid of text in quotes
        // FIXME: move to sign in sign up
        let capitalRef = ref?.collection(DataObjectType.account.rawValue).document("capital")
        capitalRef?.getDocument { doc, error in
            if let error = error {
                completion?(error)
            }
            if let doc = doc, doc.exists {
                print("Capital account exists")
                completion?(error)
            } else {
                print("Capital account creation")
                // TODO: get read of quotation
                capitalRef?.setData(["name": "capital", "amount": 0, "typeId": 4]) { error in
                    completion?(error)
                }
            }
        }
    }

    // FIXME: Change implementation
    internal func deleteAll(_ completion: (() -> Void)? = nil) {
        // FIXME: decide if delete all accounts should create capital account

        let group = DispatchGroup()

        if let uid = Auth.auth().currentUser?.uid {
            Firestore.firestore().document("users/\(uid)").delete { error in
                if let error = error {
                    fatalError(error.localizedDescription)
                }
            }
        }
        group.enter()
        deleteAll(DataObjectType.account) {
            group.leave()
        }
        group.enter()
        deleteAll(DataObjectType.transaction) {
            group.leave()
        }
        group.notify(queue: .main) {
            completion?()
        }
    }

    private func deleteAll(_ dataObject: DataObjectType, _ completion: (() -> Void)? = nil) {
        self.ref?.collection(dataObject.rawValue).getDocuments { snapshot, error in
            print(dataObject)
            if let error = error {
                print(error.localizedDescription)
                completion?()
            }
            guard let snapshot = snapshot, !snapshot.documents.isEmpty else {
                print("\(dataObject) with 0 records")
                completion?()
                return
            }
            let batch = self.fireDB.batch()
            for doc in snapshot.documents {
                batch.deleteDocument(doc.reference)
            }

            // Commit the batch
            batch.commit { err in
                completion?()
                if let err = err {
                    print("Error writing batch \(err)")
                } else {
                    print("Batch write succeeded.")
                }
            }
        }
    }
}
