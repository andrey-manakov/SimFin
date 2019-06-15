import UIKit
/// Protocol to access `LeftRightCell`
internal protocol LeftRightCellProtocol: AnyObject {
    /// Text Label inside the cell to the right
    var textLabel: UILabel? { get }
    /// Text Label inside the cell to the left
    var detailTextLabel: UILabel? { get }
    /// Accessory Type for the cell
    var accessoryType: UITableViewCell.AccessoryType { get set }
    var accessibilityIdentifier: String? { get set }
}
/// Simple cell like apple standard default style
internal class LeftRightCell: UITableViewCell, LeftRightCellProtocol {
    // MARK: - Initializers
    /// Initializes with style and reuseIdentifier. This overrides designated initializer and configure cell
    override internal init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        detailTextLabel?.textColor = .black
    }
    /// Returns nil and implemented since it is required
    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
