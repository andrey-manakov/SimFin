/// Extends `DataModelRow` to comply with Equatable protocol
extension DataModelRow: Equatable {
	/// Equatance function
    internal static func == (lhs: DataModelRow, rhs: DataModelRow) -> Bool {
        return lhs.texts == rhs.texts &&
            lhs.height == rhs.height &&
            lhs.style == rhs.style &&
            lhs.accessory == rhs.accessory
    }
}
