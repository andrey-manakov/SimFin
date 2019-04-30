import UIKit

/// Parent protocol to all View Controllers protocol
internal protocol ViewControllerProtocol: AnyObject {
    /// Generic data provided to ViewController for setup
    var data: Any? { get set }
    /// Dismisses view controller from user interface
    func dismiss(completion: (() -> Void)?)
    /// Dismisses view controller "parent" navigation view controller from user interface
    func dimissNavigationViewController(completion: (() -> Void)?)
    /// Presents view controller modally on top of current instance
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    /// Pushes viiew controller to "parent" navigation view controller
    func push(_ viewController: UIViewController)
    /// Resigns first responders text fields
    func endEditing(force: Bool)
}

extension ViewControllerProtocol {
    /// Dismisses view controller "parent" navigation view controller from user interface
    internal func dismissNavigationViewController() {
        dimissNavigationViewController(completion: nil)
    }
    /// Dismisses view controller from user interface
    internal func dismiss() {
        dismiss(completion: nil)
    }
    /// Presents view controller modally on top of current instance with or without animation
    ///
    /// Parameters:
    /// - _: view controller to present
    /// - animated: should be used animation or not
    internal func present(_ viewControllerToPresent: UIViewController, animated flag: Bool) {
        present(viewControllerToPresent, animated: flag, completion: nil)
    }
    /// Presents view controller modally on top of current instance with animation
    ///
    /// Parameters:
    /// - _: view controller to present
    internal func present(_ viewControllerToPresent: UIViewController) {
        present(viewControllerToPresent, animated: true, completion: nil)
    }
}

/// Class used for all View Controllers with common functionality
internal class ViewController: UIViewController, ViewControllerProtocol {
    // MARK: - Properties
    /// Generic data provided to ViewController for setupv
    internal var data: Any?
    // MARK: - Initializers
    /// Initializes with data
    internal convenience init(_ data: Any?) {
        self.init()
        self.data = data
    }
    /// Check that View Controller is deallocated - for debug purposes
    deinit {
        print("\(type(of: self)) deinit!")
    }
    // MARK: - Methods
    /// Configures view controller after view is loaded, in this abstract class general view controllers features are implemeted
    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    /// Dismisses view controller from user interface
    ///
    /// Parameter completion: action to perform after dismiss
    internal func dismiss(completion: (() -> Void)? = nil) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: completion)
        }
    }
    /// Dismisses "parent" navigation controller of view controller
    ///
    /// Parameter completion: action to perform after dismiss
    internal func dimissNavigationViewController(completion: (() -> Void)? = nil) {
        navigationController?.dismiss(animated: true, completion: completion)
    }
    /// Pushes view controller to the "parent" navigation view controller
    internal func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    /// Resigns first responders text fields
    internal func endEditing(force: Bool) {
        view.endEditing(force)
    }
    /// Shows alert
    ///
    /// Parameters:
    /// - message: alert message
    /// - title: alert title
    internal func alert(message: String, title: String? = nil) {
        let alert = UIAlertController(title: title ?? "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            switch action.style {
            case .default:
                print("default")

            case .cancel:
                print("cancel")

            case .destructive:
                print("destructive")
            @unknown default:
                fatalError("unknown default")
            }
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
