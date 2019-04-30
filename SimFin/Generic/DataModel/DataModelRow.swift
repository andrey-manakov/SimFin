import Foundation

/// Protocol used to access `DataModelRow`
///
/// - texts: texts used in Cell
/// - height: cell height, if null standard is used
/// - style: cell style
/// - selectionAction: action to be performed on cell selection
/// - accessory: RawValue of cell `UITableViewCell.AccessoryType`
/// - filter: value used to filter cell and define which to display
internal protocol DataModelRowProtocol {
    /// id of object represented by cell
    var id: String? { get set }
    // texts used in Cell
    var texts: [DataModelRowText: String?] { get set }
    // cell height, if null standard is used
    var height: Float? { get set }
    // cell style
    var style: CellStyle? { get set }
    // action to be performed on cell selection
    var selectAction: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)? { get set }
    // RawValue of cell `UITableViewCell.AccessoryType`
    var accessory: Int? { get set }
    // value used to filter cell and define which to display
    var filter: Any? { get set }
}

/// Struct used to configure UITableViewCell
internal struct DataModelRow: DataModelRowProtocol {
    /// id of object represented by cell
    var id: String?
    /// texts used in Cell
    internal var texts = [DataModelRowText: String?]()
    /// cell height, if null standard is used
    internal var height: Float?
    /// cell style
    internal var style: CellStyle?
    /// action to be performed on cell selection
    internal var selectAction: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)?
    /// RawValue of cell `UITableViewCell.AccessoryType`
    internal var accessory: Int?
    /// value used to filter cell and define which to display
    internal var filter: Any?

    // MARK: - Initializers

    /// initializes DataModelRow with style, selectionAction, accessory and filter
    ///
    /// - Parameters:
    ///   - style - cell style
    ///   - action: action to be perfomed on cell selection
    ///   - accessory: RawValue of cell `UITableViewCell.AccessoryType`
    ///   - filter: value used to filter cell and define which to display
    internal init(
        style: CellStyle? = nil,
        action: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)? = nil,
        accessory: Int? = nil,
        filter: Any? = nil
        ) {
        self.style = style
        self.selectAction = action
        self.accessory = accessory
        self.filter = filter
    }

    /// initializes DataModelRow with texts, style, selectionAction, accessory, filter, and action
    ///
    /// - Parameters:
    ///   - texts: texts used in Cell
    ///   - style: cell style
    ///   - action: action to be perfomed on cell selection
    ///   - accessory: RawValue of cell `UITableViewCell.AccessoryType`
    ///   - filter: value used to filter cell and define which to display
    internal init(
        id: String? = nil,
        texts: [DataModelRowText: String?] = [DataModelRowText: String?](),
        height: Float? = nil,
        style: CellStyle? = nil,
        accessory: Int? = nil,
        filter: Any? = nil,
        action: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)? = nil
         ) {
        self.id = id
        self.texts = texts
        self.height = height
        self.accessory = accessory
        self.style = style
        self.filter = filter
        self.selectAction = action
    }
}
/// Stores types / locations for the labels inside cell
///
/// - name: object / instance name - source for cell
/// - desc: object / instance description - source for cell
/// - left: label to the left
/// - right: label to the right
/// - up: label in the center - upper part
/// - down: label in the center - lower part
internal enum DataModelRowText: String, CaseIterable {
    // name of object / instance - source for cell
    case name
    // description of object / instance - source for cell
    case desc
    // label to the left
    case left
    // label in the center - upper part
    case up
    // label in the center - lower part
    case down
    // label to the right
    case right
}
