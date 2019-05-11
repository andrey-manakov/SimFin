import UIKit
/// Protocol to access `InputAmountCell`
internal protocol InputTextCellProtocol {
    /// Text field inside the cell to the right
    var textField: TextFieldProtocol { get set }
    /// Text label inside the cell to the left
    var textLabel: UILabel? { get }
}
/// Cell with input text field to the right and text label to the left
internal class InputTextCell: UITableViewCell, InputTextCellProtocol {
    // MARK: - Properties
    /// Text field inside the cell to the right
    internal var textField: TextFieldProtocol = SimpleTextField()
    // MARK: - Initializers
    /// Initializes with style and reuseIdentifier. This overrides designated initializer and configure cell
    override internal init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.add(view: textField as? UIView, withConstraints: ["H:[v(200)]-20-|", "V:|-12-[v]-12-|"])
    }
    /// Returns nil and implented since it is required
    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
