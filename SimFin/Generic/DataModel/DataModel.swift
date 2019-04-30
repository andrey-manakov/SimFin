import Foundation

/// Abstract protocol to be used for DataModel, DataModelSection, DataModelRow
internal protocol BasicDataPropertiesProtocol: CustomStringConvertible, CustomDebugStringConvertible {
    /// instance, object id - source for cell
    var id: String? { get set }
    /// instance, object name - source for cell
    var name: String? { get set }
    /// instance, object description - source for cell
    var desc: String? { get set }
}

/// Extenstion to comply with CustomStringConvertible, CustomDebugStringConvertible protocols
extension BasicDataPropertiesProtocol {
    /// description of instance
    internal var description: String {
        return "\(type(of: self)) \(id ?? "nil") \(name ?? "nil") \(desc ?? "nil")"
    }
    /// debug description of instance
    internal var debugDescription: String { return description }
}

/// Protocol for access to `DataModel` instances
internal protocol DataModelProtocol: CustomStringConvertible, CustomDebugStringConvertible {
    /// Sections of the UITableView
    var sections: [DataModelSectionProtocol] { get set }
    /// Access to the row with IndexPath
    subscript(index: IndexPath) -> DataModelRowProtocol { get set }

    /// Function used to filter rows to be shown
    ///
    /// Parameter _: function returning Bool with row argument
    func filter(_: (DataModelRowProtocol) -> (Bool)) -> DataModelProtocol
}

/// Source for the UITableView
internal struct DataModel: DataModelProtocol {
    // MARK: - Properties
    /// Sections for the UITableView
    internal var sections: [DataModelSectionProtocol] = [DataModelSection]()
    /// Description of DataModel instance
    internal var description: String {
        var desc = "-------- Data Model with \(sections.count) sections -------\n"
        for section in sections {
            desc += "\(section) \n"
        }
        return desc
    }
    /// Debug description of DataModel instance
    internal var debugDescription: String { return self.description }
    /// Access to the row with section index and row index
    internal subscript(sectionIndex: Int, rowIndex: Int) -> (name: String?, desc: String?) {
        let row = sections[sectionIndex].rows[rowIndex]
        return (row.texts[DataModelRowText.name] ?? "", row.texts[DataModelRowText.desc] ?? "")
    }
    /// Access to the row with IndexPath
    internal subscript(index: IndexPath) -> DataModelRowProtocol {
        get {
            return sections[index.section].rows[index.row]
        }
        set {
            sections[index.section].rows[index.row] = newValue
        }
    }

    // MARK: - Initializers
    /// Initializes empty data model
    internal init() {}
    /// Initializes DataModel with Sections array
    internal init(_ sections: [DataModelSectionProtocol]) {
        self.sections = sections
    }
    /// Initializes DataModel with Row array
    internal init(_ rows: [DataModelRowProtocol]) {
        self.sections.append(DataModelSection(rows))
    }

    // MARK: - Functions
    /// Filters rows to show
    ///
    /// Parameter _: function returning Bool with row argument
    internal func filter(_ filter: (DataModelRowProtocol) -> (Bool)) -> DataModelProtocol {
        return DataModel(sections.map { $0.filter(filter) })
    }
}
