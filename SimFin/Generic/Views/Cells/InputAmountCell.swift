import UIKit
/// Protocol to access `InputAmountCell`
internal protocol InputAmountCellProtocol {
    /// Text field inside the cell to the right
    var amountTextField: TextFieldProtocol { get set }
    /// Text label inside the cell to the left
    var textLabel: UILabel? { get }
}
/// Cell with input text field to the right and text label to the left
internal class InputAmountCell: UITableViewCell, InputAmountCellProtocol {
    // MARK: - Properties
    /// Text field inside the cell to the right
    internal var amountTextField: TextFieldProtocol = RightNumberField()
    // MARK: - Initializers
    /// Initializes with style and reuseIdentifier. This overrides designated initializer and configure cell
    override internal init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.add(view: amountTextField as? UIView, withConstraints: ["H:[v(100)]-20-|", "V:|[v]|"])
    }
    /// Returns nil and implented since it is required
    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
