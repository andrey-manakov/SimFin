internal protocol FIRDataProtocol {
    func create(
        _ dataObject: DataObjectType,
        with data: [String: Any?],
        completion: ((String?) -> Void)?
    )
    func update(
        _ dataObject: DataObjectType,
        id: String?,
        with values: [String: Any?],
        completion: (() -> Void)?
    )

//    func deleteAll(_ completion: (() -> Void)?)
//    func checkIfCapitalAccountExist(completion: ((Error?) -> Void)?)
}
