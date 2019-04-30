import UIKit
/// Cutomized UINavigationController class with common features for the app
internal final class NavigationController: UINavigationController {
    /// Initilize with root view controller
    ///
    /// - Parameter viewController: view controller to act as root view controller
    internal convenience init(_ viewController: UIViewController) {
        self.init()
        self.viewControllers.append(viewController)
    }
    deinit { print("\(type(of: self)) deinit!") }
}
