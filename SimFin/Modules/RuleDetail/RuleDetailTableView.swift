import UIKit

protocol RuleDetailTableViewProtocol {
    var dataSource: UITableViewDataSource? { get set }
    var delegate: UITableViewDelegate? { get set }

    func register(_ cellClass: AnyClass?, forCellReuseIdentifier: String)
    func reloadData()
}

internal final class RuleDetailTableView: UITableView, RuleDetailTableViewProtocol {
    init() {
        super.init(frame: .zero, style: .plain)
        register(LeftRightCell.self, forCellReuseIdentifier: LeftRightCell.self.description())
        register(InputAmountCell.self, forCellReuseIdentifier: InputAmountCell.self.description())
        register(InputTextCell.self, forCellReuseIdentifier: InputTextCell.self.description())
        register(DateSelectionCell.self, forCellReuseIdentifier: DateSelectionCell.self.description())
    }

    convenience init(_ dataSource: RuleDetailDataSourceProtocol?, _ delegate: UITableViewDelegate?) {
        self.init()
        self.dataSource = dataSource as? UITableViewDataSource
        self.delegate = delegate
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
