/// Protocol used to access `DataModelSection`
internal protocol DataModelSectionProtocol: BasicDataPropertiesProtocol {
    /// rows in section
    var rows: [DataModelRowProtocol] { get set }
    /// function returning Bool with row argument used for filtering rows
    func filter(_: ((DataModelRowProtocol) -> (Bool))) -> DataModelSectionProtocol
}

/// Source for UITableView section
internal struct DataModelSection: DataModelSectionProtocol {
    // MARK: - Properties
    /// id text of object / instance - source for cell
    internal var id: String?
    /// name text of object / instance - source for cell
    internal var name: String?
    /// description text of object / instance - source for cell
    internal var desc: String?
    /// rows in section of UITableView
    internal var rows: [DataModelRowProtocol] = [DataModelRow]()
    /// object / instance description
    internal var description: String {
        var description: String = "Section \(name ?? "") \(desc ?? "") with \(rows.count) rows\n"
        for row in rows {
            description += "\(row)\n"
        }
        return description
    }
    /// Access to the row with row index
    internal subscript(rowIndex: Int) -> (name: String?, desc: String?) {
        let row = rows[rowIndex]
        return (row.texts[DataModelRowText.name] ?? "", row.texts[DataModelRowText.desc] ?? "")
//        return (row.texts[.name], row.texts[.desc])
    }

    // MARK: - Initializers
    /// Initializes empty section
    internal init() {}
    /// Initializes empty section
    internal init(_ rows: [DataModelRowProtocol]) {
        self.rows = rows
    }
    /// Initializes section with simple set of strings
    internal init(_ labels: [String]) {
        for label in labels {
            rows.append(DataModelRow(texts: [.name: label]))
        }
    }

    // MARK: - Methods
    /// Filters rows to show
    internal func filter(_ filter: ((DataModelRowProtocol) -> (Bool))) -> DataModelSectionProtocol {
        return DataModelSection(self.rows.filter(filter))
    }
}
