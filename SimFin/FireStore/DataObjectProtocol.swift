internal protocol DataObjectProtocol {
    var data: [String: Any] { get }

    init(_ data: [String: Any])
}
