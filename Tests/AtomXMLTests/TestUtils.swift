@testable import AtomXML

extension AtomXMLPath: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Component...) {
        self.init(components: elements)
    }
}

extension AtomXMLPath.Component: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(name: value, attribute: nil)
    }
}
