import XCTest

extension SimFinUITests {
    private enum AccountType: String, CaseIterable {
        case asset, liability, revenue, expense, capital
    }
    typealias Account = (name: String, type: String)
    typealias Transaction = (from: Account, to: Account, amount: Int)
    typealias Rule = (transaction: Transaction, repeatMode: String)
}

internal class SimFinUITests: XCTestCase {
    private static var app: XCUIApplication?
    private static let randomCount = 6
    private lazy var app: XCUIApplication = SimFinUITests.app ?? XCUIApplication() // TODO: Refactor
    private let amounts = (0..<SimFinUITests.randomCount).map { _ in Int.random(in: 0 ..< 1_000) }
    private let accounts: [Account] = (0..<SimFinUITests.randomCount).map { _ in
        (String((0..<Int.random(in: 1 ..< 6)).map { _ in "abcdefghijklmnopqrstuvwxyz".randomElement() ?? "x" }),
        SimFinUITests.AccountType.allCases.randomElement()!.rawValue)
    }
    private lazy var transactions: [Transaction] = [
        (from: self.accounts[0], to: self.accounts[1], amount: self.amounts[0]),
        (from: self.accounts[1], to: self.accounts[2], amount: self.amounts[1]),
        (from: self.accounts[2], to: self.accounts[0], amount: self.amounts[3])]
    // FIXME: make repeat mode random
    private lazy var rules: [Rule] = self.transactions.map { ($0, "annually") }
    //    private let accountNames: [String] = (0..<SimFinUITests.randomCount).map { _ in String((0..<Int.random(in: 1 ..< 6)).map { _ in "abcdefghijklmnopqrstuvwxyz".randomElement() ?? "x" }) }
    //    private let types = (0..<SimFinUITests.randomCount).map { _ in SimFinUITests.AccountType.allCases.randomElement()!.rawValue }
    private lazy var accountNames: [String] = accounts.map { $0.name }
    private lazy var types: [String] = accounts.map { $0.type }

    override internal func setUp() {
        super.setUp()
        // TODO: move to instance method
        continueAfterFailure = true
        SimFinUITests.app = XCUIApplication()
        SimFinUITests.app?.launch()
    }

    override internal func tearDown() {
        super.tearDown()
        // Deletes app
        //        Springboard.deleteMyApp()
    }

    internal func testCreateAccount() {
        XCTAssert(self.perform {
            self.create(self.accounts[0]) && self.delete(self.accounts[0])
        })
    }
    internal func testCreateTransaction() {
        XCTAssert(self.perform {
            create(transactions[0]) &&
            check([(account: accounts[0], value: -amounts[0]), (account: accounts[1], value: amounts[0])]) &&
            delete(Array(accounts[..<2]))
        })
    }
    internal func testChangeTransactionAmount() {
        XCTAssert(self.perform {
            create(transactions[0]) &&
            changeTransaction(amount: amounts[1]) &&
            check([(account: accounts[0], value: -amounts[1]), (account: accounts[1], value: amounts[1])]) &&
            delete(Array(accounts[..<2]))
        })
    }
    internal func testCreateRule() {
        XCTAssert(self.perform {
            create(rules[0]) &&
                // FIXME: check dates and repeat
//            check([(account: accounts[0], value: -amounts[0]), (account: accounts[1], value: amounts[0])]) &&
            delete(Array(accounts[..<2]))
        })
    }
    internal func testMain() {
        // Log out Log in
        XCTAssert(logOut())
        XCTAssert(logIn())

        // Create three accounts and three transactions
        XCTAssert(createAccountsAndTransaction(amounts[0], from: accounts[0], to: accounts[1]))
        XCTAssert(createAccountsAndTransaction(amounts[1], from: accounts[1], to: accounts[2]))
        XCTAssert(createAccountsAndTransaction(amounts[2], from: accounts[2], to: accounts[0]))

        // Check account values based on the transactions
        XCTAssert(check(accounts[0], value: -amounts[0] + amounts[2]))
        XCTAssert(check(accounts[1], value: -amounts[1] + amounts[0]))
        XCTAssert(check(accounts[2], value: -amounts[2] + amounts[1]))

        // Change transaction and check that account amounts changed correctly
        XCTAssert(changeTransactionTo(amounts[3], from: accounts[0], to: accounts[2]))
        XCTAssert(check(accounts[0], value: -amounts[0] - amounts[3]))
        XCTAssert(check(accounts[1], value: -amounts[1] + amounts[0]))
        XCTAssert(check(accounts[2], value: amounts[1] + amounts[3]))

        // Delete account and check indirectly that transaction was deleted through the check of accunt value change
        XCTAssert(delete(accounts[0]))
        XCTAssert(check(accounts[1], value: -amounts[1]))
        XCTAssert(check(accounts[2], value: amounts[1]))

        // Delete transaction and check account values
        app.tables["v"].cells["cell_0"].longSwipe(.left)
        XCTAssert(check(accounts[1], value: 0))
        XCTAssert(check(accounts[2], value: 0))

        // Clean accounts
        XCTAssert(delete(accounts[1]))
        XCTAssert(delete(accounts[2]))

        // Logout
        XCTAssert(logOut())
    }

    private func perform(_ test: () -> Bool) -> Bool {
        var testResults = [Bool]()
        testResults.append(logOut())
        testResults.append(logIn())
        testResults.append(test())
        testResults.append(logOut())
        return testResults.filter { $0 }.count == testResults.count
    }

    private func create(_ rule: Rule) -> Bool {
        app.tabBars.buttons["Rules"].tap()
        app.navigationBars["Rules"].buttons["Add"].tap()
        tap(String(rule.transaction.amount))
        app.tables["v"].staticTexts["from"].tap()
        XCTAssert(addAndTap(account: rule.transaction.from))
        app.tables["v"].staticTexts["to"].tap()
        XCTAssert(addAndTap(account: rule.transaction.to))
        app.navigationBars["Rule Details"].buttons["Done"].tap()
        func check(id: String, value: String) -> Bool {
            return app.tables["v"].cells["cell_0"].staticTexts.element(matching: .staticText, identifier: id).label == value
        }
        print(check(id: "from", value: "from: \(rule.transaction.from.name)"))
        print(check(id: "to", value: "to: \(rule.transaction.to.name)"))
        print(check(id: "amount", value: "\(rule.transaction.amount)"))
        return check(id: "from", value: "from: \(rule.transaction.from.name)") &&
            check(id: "to", value: "to: \(rule.transaction.to.name)") &&
            check(id: "amount", value: "\(rule.transaction.amount)")
    }

    private func create(_ account: Account) -> Bool {
        app.tabBars.buttons["Accounts"].tap()
        app.navigationBars["Accounts"].buttons["Add"].tap()
        tap(account.name)
        print(account.type)
        app.buttons[account.type].tap()
        app.navigationBars["Account Details"].buttons["Done"].tap()
        print(account.type)
        app.buttons[account.type].tap()
        let testResult = app.tables["v"].staticTexts[account.name].waitForExistence(timeout: 10)
        app.tables["v"].staticTexts[account.name].tap()
        app.tabBars.buttons["Transactions"].tap()
        return testResult
    }

    private func create(_ transactions: [Transaction]) -> Bool {
        return transactions.map { create($0) }.filter { $0 }.count == transactions.count
    }

    private func create(_ transaction: Transaction) -> Bool {
        app.navigationBars["Transactions"].buttons["Add"].tap()
        tap(String(transaction.amount))
        app.tables["v"].staticTexts["from"].tap()
        XCTAssert(addAndTap(account: transaction.from))
        app.tables["v"].staticTexts["to"].tap()
        XCTAssert(addAndTap(account: transaction.to))
        app.navigationBars["Transaction Details"].buttons["Done"].tap()
        func check(id: String, value: String) -> Bool {
            return app.tables["v"].cells["cell_0"].staticTexts.element(matching: .staticText, identifier: id).label == value
        }
        // FIXME: check date
        return check(id: "from", value: "from: \(transaction.from.name)") &&
            check(id: "to", value: "to: \(transaction.to.name)") &&
            check(id: "amount", value: "\(transaction.amount)")
    }
    /// Main integral UI Test

    private func logOut() -> Bool {
        if app.tabBars.buttons["Transactions"].exists {
            app.tabBars.buttons["Transactions"].tap()
        }
        if app.navigationBars["Transactions"].exists {
            app.navigationBars["Transactions"].buttons["Log Out"].tap()
        }
        return app.staticTexts["CAPITAL"].exists
    }

    private func logIn() -> Bool {
        guard app.staticTexts["CAPITAL"].exists else {
            return false
        }
        app.textFields["loginTextField"].tap()
        tap("test@mail.ru")
        app.secureTextFields["passwordTextField"].tap()
        tap("friend")
        app.buttons["Sign In"].tap()
        //        print(app.descendants(matching: .any).debugDescription)
        return app.navigationBars["Transactions"].waitForExistence(timeout: 10)
    }
    private func delete(_ accounts: [Account]) -> Bool {
        return accounts.map { delete($0) }.filter { $0 }.count == accounts.count
    }
    private func delete(_ account: Account) -> Bool {
        // FIXME: change logic - delete through the Accounts tab
        app.tabBars.buttons["Accounts"].tap()
        app.buttons[account.type].tap()
        app.tables["v"].cells.containing(.staticText, identifier: account.name).element.longSwipe(.left)
        let result = !app.tables["v"].cells.containing(.staticText, identifier: account.name).element.waitForExistence(timeout: 2)
        app.tabBars.buttons["Transactions"].tap()
        return result
    }

    private func deleteTroughTransaction(_ account: Account) -> Bool {
        app.navigationBars["Transactions"].buttons["Add"].tap()
        app.tables["v"].staticTexts["from"].tap()
        app.buttons[account.type].tap()
        app.tables["v"].cells.containing(.staticText, identifier: account.name).element.longSwipe(.left)
        let result = !app.tables["v"].cells.containing(.staticText, identifier: account.name).element.waitForExistence(timeout: 2)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        return result
    }

    private func addAndTap(account: Account) -> Bool {
        app.buttons[account.type].tap()
        if app.tables["v"].staticTexts[account.name].exists {
            app.tables["v"].staticTexts[account.name].tap()
            return true
        } else {
            app.navigationBars["Accounts"].buttons["Add"].tap()
            tap(account.name)
            print(account.type)
            app.buttons[account.type].tap()
            app.navigationBars["Account Details"].buttons["Done"].tap()
            print(account.type)
            app.buttons[account.type].tap()
            let testResult = app.tables["v"].staticTexts[account.name].waitForExistence(timeout: 2)
            app.tables["v"].staticTexts[account.name].tap()
            return testResult
        }
    }

    private func createAccountsAndTransaction(_ amount: Int, from: Account, to: Account) -> Bool {
        app.navigationBars["Transactions"].buttons["Add"].tap()
        tap(String(amount))
        app.tables["v"].staticTexts["from"].tap()
        XCTAssert(addAndTap(account: from))
        app.tables["v"].staticTexts["to"].tap()
        XCTAssert(addAndTap(account: to))
        app.navigationBars["Transaction Details"].buttons["Done"].tap()
        func check(id: String, value: String) -> Bool {
            return app.tables["v"].cells["cell_0"].staticTexts.element(matching: .staticText, identifier: id).label == value
        }
        // FIXME: check date
        print(check(id: "from", value: "from: \(from.name)"))
        print(app.tables["v"].cells["cell_0"].staticTexts.element(matching: .staticText, identifier: "from").label)
        print("from: \(from.name)")
        print(check(id: "to", value: "to: \(to.name)"))
        print(check(id: "amount", value: "\(amount)"))
        return check(id: "from", value: "from: \(from.name)") &&
            check(id: "to", value: "to: \(to.name)") &&
            check(id: "amount", value: "\(amount)")
    }

    private func createRule(_ amount: Int, from: Account, to: Account) -> Bool {
        app.navigationBars["Transactions"].buttons["Add"].tap()
        tap(String(amount))
        app.tables["v"].staticTexts["from"].tap()
        XCTAssert(addAndTap(account: from))
        app.tables["v"].staticTexts["to"].tap()
        XCTAssert(addAndTap(account: to))
        app.navigationBars["Transaction Details"].buttons["Done"].tap()
        func check(id: String, value: String) -> Bool {
            return app.tables["v"].cells["cell_0"].staticTexts.element(matching: .staticText, identifier: id).label == value
        }
        // FIXME: check date
        print(check(id: "from", value: "from: \(from.name)"))
        print(app.tables["v"].cells["cell_0"].staticTexts.element(matching: .staticText, identifier: "from").label)
        print("from: \(from.name)")
        print(check(id: "to", value: "to: \(to.name)"))
        print(check(id: "amount", value: "\(amount)"))
        return check(id: "from", value: "from: \(from.name)") &&
            check(id: "to", value: "to: \(to.name)") &&
            check(id: "amount", value: "\(amount)")
    }

    private func changeTransactionTo(_ amount: Int, from: Account, to: Account) -> Bool {
        app.tables["v"].cells["cell_0"].tap()
        app.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 4))
        tap(String(amount))
        app.tables["v"].staticTexts["from"].tap()
        XCTAssert(addAndTap(account: from))
        app.tables["v"].staticTexts["to"].tap()
        XCTAssert(addAndTap(account: to))
        app.navigationBars["Transaction Details"].buttons["Done"].tap()
        func check(id: String, value: String) -> Bool {
            return app.tables["v"].cells["cell_0"].staticTexts.element(matching: .staticText, identifier: id).label == value
        }
        // FIXME: check date
        return check(id: "from", value: "from: \(from.name)") &&
            check(id: "to", value: "to: \(to.name)") &&
            check(id: "amount", value: "\(amount)")
    }
    private func changeTransaction(amount: Int) -> Bool {
        app.tables["v"].cells["cell_0"].tap()
        app.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 4))
        tap(String(amount))
        app.navigationBars["Transaction Details"].buttons["Done"].tap()
        if app.tables["v"].cells["cell_0"].waitForExistence(timeout: 5) {
            return app.tables["v"].cells["cell_0"].staticTexts.element(matching: .staticText, identifier: "amount").label == "\(amount)"
        } else {
            return false
        }
//        return app.tables["v"].cells["cell_0"].staticTexts.element(matching: .staticText, identifier: "amount").label == "\(amount)"
    }
    private func check(_ accountValues: [(account: Account, value: Int)]) -> Bool {
        return accountValues.map { check($0.account, value: $0.value) }.filter { $0 }.count == accountValues.count
    }
    private func check(_ account: Account, value: Int) -> Bool {
        app.navigationBars["Transactions"].buttons["Add"].tap()
        app.tables["v"].staticTexts["from"].tap()
        app.buttons[account.type].tap()
        let result = app.tables["v"].cells.containing(.staticText, identifier: account.name).element.staticTexts["amount"].label == "\(value)"
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
