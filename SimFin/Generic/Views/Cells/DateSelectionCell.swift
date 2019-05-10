import UIKit
/// Protocol to access `DateSelectionCell`
internal protocol DateSelectionCellProtocol {
    /// Action on date change
    var actionOnDateChange: ((_ date: Date) -> Void)? { get set }
    /// Date selected currently inside cell's date picker
    var date: Date? { get set }
}
/// Cell with date picker
internal final class DateSelectionCell: UITableViewCell, DateSelectionCellProtocol {
    // MARK: - Properties
    /// Date selected currently inside cell's date picker
    internal var date: Date? = Date() { didSet { if let date = date { datePicker.date = date } } }
    /// Date Picker inside cell
    internal var datePicker: DatePickerProtocol = DatePicker()
    /// Action on date change, this variable sets date picker's action on change date
    internal var actionOnDateChange: ((_ date: Date) -> Void)? {
        didSet { datePicker.actionOnDateChange = self.actionOnDateChange }
    }
    // MARK: - Initializers
    /// Initializes with style and reuseIdentifier. This overrides designated initializer and configure cell
    override internal init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.add(view: datePicker as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
    }
    /// Returns nil and implented since it is required
    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
