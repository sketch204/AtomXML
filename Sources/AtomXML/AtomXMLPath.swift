public struct AtomXMLPath {
    public var components: [Component]
    
    public init(components: [Component] = []) {
        self.components = components
    }
}

extension AtomXMLPath {
    public struct Component {
        public let name: String
        public let attribute: String?
    }
}

extension AtomXMLPath {
    public func appending(component: Component) -> Self {
        var copy = self
        copy = replacingLastComponentAttribute(with: nil)
        copy.components.append(component)
        return copy
    }
    
    public func appending(componentName: String) -> Self {
        appending(component: Component(name: componentName, attribute: nil))
    }
}

extension AtomXMLPath {
    public func replacingLastComponent(with component: Component) -> Self {
        guard !components.isEmpty else { return self }
        
        var copy = self
        copy.components.removeLast()
        copy.components.append(component)
        return copy
    }
    
    public func replacingLastComponentAttribute(with attribute: String?) -> Self {
        guard let lastComponent = components.last else { return self }
        return replacingLastComponent(with: Component(name: lastComponent.name, attribute: attribute))
    }
}

extension AtomXMLPath.Component: CustomStringConvertible {
    public var description: String {
        if let attribute {
            "\(name)(\(attribute))"
        } else {
            "\(name)"
        }
    }
}

extension AtomXMLPath: CustomStringConvertible {
    public var description: String {
        components.map(\.description).joined(separator: " -> ")
    }
}
