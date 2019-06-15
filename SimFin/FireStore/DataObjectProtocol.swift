internal protocol DataObjectProtocol {
    var data: [String: Any] { get }
    var id: String? { get set }

    init(_ data: [String: Any])
}
