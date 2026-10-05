/// A selectable choice (breed, coat, groom, accessory, size) identified by a command-line friendly key.
protocol Variant {
    var key: String { get }
    var title: String { get }
}

extension Collection where Element: Variant {
    func named(_ key: String) -> Element? { first { $0.key == key } }
}
