import UIKit

protocol TableViewProtocol {
    var didSelect: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)? { get set }
}

/// Abstract Class used for all TableViews
internal class TableView: UITableView, UITableViewDataSource, UITableViewDelegate, TableViewProtocol {
    internal var dataFormula: (() -> (DataModelProtocol))? {
        didSet {
            reloadData()
        }
    }
    internal var localData: DataModelProtocol? {
        didSet {
            reloadData()
        }
    }
    internal var data: DataModelProtocol {
        return (dataFormula?() ?? localData ?? DataModel()).filter(self.filter ?? { _ in true })
    }
    internal var filter: ((DataModelRowProtocol) -> (Bool))? {
        didSet {
            reloadData()
        }
    }
    internal var didSelect: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)?

    // MARK: - Define sections

    internal func numberOfSections(in tableView: UITableView) -> Int {
        return data.sections.count
    }

    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if data.sections[section].name == nil {
            return 0
        } else {
            return  44
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    internal init() {
        super.init(frame: CGRect.zero, style: UITableView.Style.plain)
        self.dataSource = self
        self.delegate = self
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }

    // height def warning appears if i comment two functions below
    internal func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
        ) -> CGFloat {
        return 45
    }
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    /// Action on cell selection
    ///
    /// - Parameters:
    ///   - tableView: current TableView
    ///   - indexPath: index path of selected cell
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // general select action
        didSelect?(data[indexPath], indexPath)
        // specific to the cell select action
        data[indexPath].selectAction?(data[indexPath], indexPath)
    }
}
