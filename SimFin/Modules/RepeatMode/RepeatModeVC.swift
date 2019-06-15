import UIKit

internal final class RepeatModeVC: ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        var table: TableViewProtocol = RepeatModeTableView()

        let selectedRepeatMode: RepeatMode
        let selectionAction: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)?
        if let data = data as? (selectedRepeatMode: RepeatMode?, selectionAction: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)) {
            selectedRepeatMode = data.selectedRepeatMode ?? .monthly
            selectionAction = data.selectionAction
        } else {
            selectedRepeatMode = .monthly
            selectionAction = nil
        }

        table.didSelect = { [unowned self] row, ix in
            selectionAction?(row, ix)
            self.dismiss()
        }

        let rows = RepeatMode.allCases.map {
            DataModelRow(id: $0.rawValue,
                         texts: [DataModelRowText.name: $0.rawValue],
                         accessory: $0 == selectedRepeatMode ? 3 : 0)
        }
        table.localData = DataModel(rows)

        view.add(view: table)
    }
}
