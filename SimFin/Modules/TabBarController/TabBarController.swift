import UIKit

internal protocol TabBarControllerProtocol {
}

/// Main viewcontroller shown upon successful login
internal final class TabBarController: UITabBarController, TabBarControllerProtocol {
    internal init() {
        super.init(nibName: nil, bundle: nil)
        viewControllers = [
            NavigationController(TransactionListVC()),
            NavigationController(AccountListVC()),
            NavigationController(RuleListVC())
        ]
        tabBar.items?[0].image = UIImage(named: "Transactions")
        tabBar.items?[0].title = "Transactions"
        tabBar.items?[1].image = UIImage(named: "Accounts")
        tabBar.items?[1].title = "Accounts"
        tabBar.items?[2].image = UIImage(named: "Rules")
        tabBar.items?[2].title = "Rules"
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }

    deinit { print("\(type(of: self)) deinit!") }

    internal struct TabBarItem {
    }
}
