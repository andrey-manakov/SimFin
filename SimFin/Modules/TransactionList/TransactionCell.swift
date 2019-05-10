import UIKit
/// Protocol to access `TransactionCell`
internal protocol TransactionCellProtocol: AnyObject {
    /// Label for date of transaction
    var date: SimpleLabelProtocol { get set }
    /// Label for `Account` from which funds are withdrawn
    var from: SimpleLabelProtocol { get set }
    /// Label for `Account` to which funds are transferred
    var to: SimpleLabelProtocol { get set }
    /// Label for transaction amount
    var amount: SimpleLabelProtocol { get set }
    /// Accessability Identifier
    var accessibilityIdentifier: String? { get set }
}

internal final class TransactionCell: UITableViewCell, TransactionCellProtocol {
    // MARK: - Properties
    /// Label for date of transaction
    internal var date: SimpleLabelProtocol = SimpleLabel(alignment: .center, lines: 2)
    /// Label for `Account` from which funds are withdrawn
    internal var from: SimpleLabelProtocol = SimpleLabel()
    /// Label for `Account` to which funds are transferred
    internal var to: SimpleLabelProtocol = SimpleLabel()
    /// Label for transaction amount
    internal var amount: SimpleLabelProtocol = NumberLabel()
    // MARK: - Initializers
    /// Initializes with style and reuseIdentifier. This overrides designated initializer and configure cell
    override internal init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.add(
            views: [
                "date": date as? UIView, "from": from as? UIView,
                "to": to as? UIView, "amount": amount as? UIView
            ],
            withConstraints: [
                "H:|-15-[date(70)]-10-[from]-5-[amount(100)]-5-|",
                "H:|-95-[to(==from)]", "V:|[date]|", "V:|[from(22)]",
                "V:[to(22)]|", "V:|[amount]|"
            ])
    }
    /// Returns nil and implented since it is required
    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
