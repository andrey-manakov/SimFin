import UIKit

internal protocol DatePickerProtocol: AnyObject {
    var actionOnDateChange: ((_ date: Date) -> Void)? { get set }
    var date: Date { get set }
}

internal final class DatePicker: UIDatePicker, DatePickerProtocol {
    internal var actionOnDateChange: ((_ date: Date) -> Void)?

    internal init(actionOnDateChange: ((_ date: Date) -> Void)? = nil) {
        super.init(frame: .zero)
        datePickerMode = .date
        addTarget(self, action: #selector(dateChanged), for: UIControl.Event.valueChanged)
    }

    /// Required initializer returns nil
    ///
    /// - Parameter aDecoder: parameter for state preservation
    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }

    @objc internal func dateChanged() {
        actionOnDateChange?(date)
    }
}
