/// A breed: its build, plus the coats and groomings that suit it. The first coat and groom are its defaults.
struct Breed: Variant {
    let key: String
    let title: String
    var anatomy = Anatomy()
    let coats: [Coat]
    let grooms: [Groom]

    static let all: [Breed] = [
        .shihTzu, .poodle, .bernedoodle, .goldenRetriever, .labrador, .germanShepherd, .husky,
        .corgi, .dachshund, .beagle, .pug, .pomeranian, .borderCollie, .dalmatian,
    ]

    static let fallback = Breed.shihTzu
}
