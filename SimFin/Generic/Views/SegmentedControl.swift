import UIKit

internal protocol SegmentedControlProtocol: AnyObject {
    var selectedSegmentIndex: Int { get set }
}

internal class SegmentedControl: UISegmentedControl, SegmentedControlProtocol {
    internal var actionOnValueChange: ((Int) -> Void)?

    internal init(_ titles: [String], _ actionOnValueChange: ((Int) -> Void)? = nil) {
        super.init(frame: CGRect.zero)
        for index in 0..<titles.count {
            self.insertSegment(withTitle: titles[index], at: index, animated: false)
            self.selectedSegmentIndex = 0
        }
        addTarget(self, action: #selector(self.didChangeValue(sender:)), for: UIControl.Event.valueChanged)
        self.actionOnValueChange = actionOnValueChange
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }

    @objc internal func didChangeValue(sender: UISegmentedControl) {
        actionOnValueChange?(selectedSegmentIndex)
    }
}
