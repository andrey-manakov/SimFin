import UIKit

internal final class RuleDetailVC: ViewController {
    /// Array of rule detail items
    internal var service = RuleDetailService()
    internal var ruleItems: [RuleItem] = [.amount, .from, .to, .dateBegin, .dateEnd, .repeatMode]
    internal var rule: Rule?
    internal var ruleItemsDesc: [RuleItem: String?] {
        let sequence = self.ruleItems.map { ($0, self.service.getRuleData(rule: self.rule ?? Rule(), item: $0)) }
        return Dictionary(uniqueKeysWithValues: sequence)
    }
    /// Table with interface elements
    internal var dataSource: RuleDetailDataSourceProtocol? = RuleDetailDataSource()
    private lazy var table: RuleDetailTableViewProtocol = RuleDetailTableView(dataSource, self)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rule Details"
        dataSource?.actionOnAmountUpdate = { [unowned self] amount in
            self.rule?.amount = amount
            self.reload()
        }
        dataSource?.actionOnDateEndUpdate = { [unowned self] date in
            self.rule?.endDate = date
            self.reload()
        }
        dataSource?.actionOnDateBeginUpdate = { [unowned self] date in
            self.rule?.beginDate = date
            self.reload()
        }
        let doneAction: (() -> Void)?
        if let data = self.data as? (ruleId: RuleId?, doneAction: (() -> Void)?) {
            doneAction = data.doneAction
            if let ruleId = data.ruleId {
                self.rule = service.getRule(withId: ruleId)
            } else {
                self.rule = Rule()
            }
        } else {
            doneAction = nil
        }
        view.add(view: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
        navigationItem.rightBarButtonItem = BarButtonItem("Done") { [unowned self, service] in
            self.dataSource?.resignAmountTextFieldFirstResponder()
            _ = service.save(self.rule)
            doneAction?()
            self.dismiss()
        }
        reload()
    }

    override func reload() {
        super.reload()
        dataSource?.ruleItems = ruleItems
        dataSource?.ruleItemsDesc = ruleItemsDesc
        table.reloadData()
    }
}
