import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    internal var testing: Bool = false
    // swiftlint:disable discouraged_optional_collection
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = NavigationController(TransactionListVC())
        if let window: UIWindow = self.window {
            window.makeKeyAndVisible()
            return true
        } else {
            return false
        }
    }
}
