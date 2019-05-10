import XCTest

extension SimFinUITests {
    private enum AccountType: String, CaseIterable {
        case asset, liability, revenue, expense, capital
    }
}

internal class SimFinUITests: XCTestCase {
    private static var app: XCUIApplication?
    private static let randomCount = 6
    private lazy var app: XCUIApplication = SimFinUITests.app ?? XCUIApplication() // TODO: Refactor
    private let accountNames: [String] = (0..<SimFinUITests.randomCount).map { _ in String((0..<Int.random(in: 1 ..< 6)).map { _ in "abcdefghijklmnopqrstuvwxyz".randomElement() ?? "x" }) }
    private let amounts = (0..<SimFinUITests.randomCount).map { _ in Int.random(in: 0 ..< 1_000) }
    private let types = (0..<SimFinUITests.randomCount).map { _ in SimFinUITests.AccountType.allCases.randomElement()!.rawValue }

    override internal func setUp() {
        super.setUp()
        continueAfterFailure = true // TODO: move to instance method
        SimFinUITests.app = XCUIApplication()
        SimFinUITests.app?.launch()
    }

    override internal func tearDown() {
        super.tearDown()
//        Springboard.deleteMyApp()
    }

    internal func testCreateTransaction() {
        // Create three accounts and three transactions
        XCTAssert(createAccountsAndTransaction(amounts[0], from: accountNames[0], fromType: types[0], to: accountNames[1], toType: types[1]))
        XCTAssert(createAccountsAndTransaction(amounts[1], from: accountNames[1], fromType: types[1], to: accountNames[2], toType: types[2]))
        XCTAssert(createAccountsAndTransaction(amounts[2], from: accountNames[2], fromType: types[2], to: accountNames[0], toType: types[0]))
        // Check account values based on the transactions
        XCTAssert(checkAccount(name: accountNames[0], type: types[0], value: -amounts[0] + amounts[2]))
        XCTAssert(checkAccount(name: accountNames[1], type: types[1], value: -amounts[1] + amounts[0]))
        XCTAssert(checkAccount(name: accountNames[2], type: types[1], value: -amounts[2] + amounts[1]))
        // Check sorting order (the latest transaction should go first)

        // Change transaction
        XCTAssert(changeTransactionTo(amounts[3], from: accountNames[0], fromType: types[0], to: accountNames[2], toType: types[2]))
        XCTAssert(checkAccount(name: accountNames[0], type: types[0], value: -amounts[0] - amounts[3]))
        XCTAssert(checkAccount(name: accountNames[1], type: types[1], value: -amounts[1] + amounts[0]))
        XCTAssert(checkAccount(name: accountNames[2], type: types[1], value: amounts[1] + amounts[3]))

        // Delete account
        XCTAssert(deleteAccount(accountNames[0]))
        XCTAssert(checkAccount(name: accountNames[1], type: types[1], value: -amounts[1]))
        XCTAssert(checkAccount(name: accountNames[2], type: types[2], value: amounts[1]))

        // Delete transaction
        app.tables["v"].cells["cell_0"].longSwipe(.left)
        XCTAssert(checkAccount(name: accountNames[1], type: types[1], value: 0))
        XCTAssert(checkAccount(name: accountNames[2], type: types[1], value: 0))

        // Clean accounts
        XCTAssert(deleteAccount(accountNames[1]))
        XCTAssert(deleteAccount(accountNames[2]))
    }

    private func deleteAccount(_ name: String) -> Bool {
        app.navigationBars["Transaction List"].buttons["Add"].tap()
        app.tables["v"].staticTexts["from"].tap()
        app.tables["v"].cells.containing(.staticText, identifier: name).element.longSwipe(.left)
        let result = !app.tables["v"].cells.containing(.staticText, identifier: name).element.exists
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        return result
    }

    private func addAndTapAccount(_ name: String, ofType type: String) -> Bool {
        if app.tables["v"].staticTexts[name].exists {
            app.tables["v"].staticTexts[name].tap()
            return true
        } else {
            app.navigationBars["Accounts"].buttons["Add"].tap()
            tap(name)
            app.buttons[type].tap()
            app.navigationBars["Account Details"].buttons["Done"].tap()
            let testResult = app.tables["v"].staticTexts[name].waitForExistence(timeout: 1)
            app.tables["v"].staticTexts[name].tap()
            return testResult
        }
    }

    private func createAccountsAndTransaction(_ amount: Int, from: String, fromType: String, to: String, toType: String) -> Bool {
        app.navigationBars["Transaction List"].buttons["Add"].tap()
        tap(String(amount))
        app.tables["v"].staticTexts["from"].tap()
        XCTAssert(addAndTapAccount(from, ofType: fromType))
        app.tables["v"].staticTexts["to"].tap()
        XCTAssert(addAndTapAccount(to, ofType: toType))
        app.navigationBars["Transaction Details"].buttons["Done"].tap()
        func check(id: String, value: String) -> Bool {
            return app.tables["v"].cells["cell_0"].staticTexts.element(matching: .staticText, identifier: id).label == value
        }
        // FIXME: check date
        return check(id: "from", value: "from: \(from)") &&
            check(id: "to", value: "to: \(to)") &&
            check(id: "amount", value: "\(amount)")
    }

    private func changeTransactionTo(_ amount: Int, from: String, fromType: String, to: String, toType: String) -> Bool {
        app.tables["v"].cells["cell_0"].tap()
        app.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 4))
        tap(String(amount))
        app.tables["v"].staticTexts["from"].tap()
        XCTAssert(addAndTapAccount(from, ofType: fromType))
        app.tables["v"].staticTexts["to"].tap()
        XCTAssert(addAndTapAccount(to, ofType: toType))
        app.navigationBars["Transaction Details"].buttons["Done"].tap()
        func check(id: String, value: String) -> Bool {
            return app.tables["v"].cells["cell_0"].staticTexts.element(matching: .staticText, identifier: id).label == value
        }
        // FIXME: check date
        return check(id: "from", value: "from: \(from)") &&
            check(id: "to", value: "to: \(to)") &&
            check(id: "amount", value: "\(amount)")
    }

    private func checkAccount(name: String, type: String, value: Int) -> Bool {
        app.navigationBars["Transaction List"].buttons["Add"].tap()
        app.tables["v"].staticTexts["from"].tap()
        print(app.tables["v"].cells.containing(.staticText, identifier: name).element.staticTexts["amount"].label)
        print(value)
        let result = app.tables["v"].cells.containing(.staticText, identifier: name).element.staticTexts["amount"].label == "\(value)"
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        return result
    }

    private func tap(_ text: String) {
        _ = text.map {
            app.keys[String($0)].tap()
        }
    }

    private func randomString(_ length: Int) -> String {
        return String((0..<length).map { _ in "abcdefghijklmnopqrstuvwxyz".randomElement() ?? "x" })
    }

    private func randomType() -> String {
        return SimFinUITests.AccountType.allCases.randomElement()!.rawValue
    }
}
