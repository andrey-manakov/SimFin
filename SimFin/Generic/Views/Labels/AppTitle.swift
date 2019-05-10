/// Label for App title at start screen
internal class AppTitle: UILabel {
    // MARK: - Initializers
    /// Initializes and configure
    internal init() {
        super.init(frame: CGRect.zero)
        text = "CAPITAL"
        font = UIFont(name: "HelveticaNeue-Bold", size: 50)
        textAlignment = .center
    }
    /// Returns nil and implented since it is required
    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
