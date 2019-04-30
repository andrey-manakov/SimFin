import UIKit

protocol TransactionDetailTableViewProtocol {
    var dataSource: UITableViewDataSource? { get set }
    var delegate: UITableViewDelegate? { get set }

    func register(_ cellClass: AnyClass?, forCellReuseIdentifier: String)
    func reloadData()
}

internal final class TransactionDetailTableView: UITableView, TransactionDetailTableViewProtocol {
    init() {
        super.init(frame: .zero, style: .plain)
        register(LeftRightCell.self, forCellReuseIdentifier: LeftRightCell.self.description())
        register(InputAmountCell.self, forCellReuseIdentifier: InputAmountCell.self.description())
    }

    convenience init(_ dataSource: TransactionDetailDataSourceProtocol?, _ delegate: UITableViewDelegate?) {
        self.init()
        self.dataSource = dataSource as? UITableViewDataSource
        self.delegate = delegate
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    //    func test() {
//        register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)
//    }
}
