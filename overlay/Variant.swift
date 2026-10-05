/// A selectable look (coat, grooming style, accessory) identified by a command-line friendly key.
protocol Variant {
    var key: String { get }
    var title: String { get }
    static var all: [Self] { get }
    /// Used when nothing (or something unknown) is configured.
    static var fallback: Self { get }
}

extension Variant {
    static func named(_ key: String) -> Self? { all.first { $0.key == key } }
}
