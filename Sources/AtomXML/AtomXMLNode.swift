public struct AtomXMLNode {
    public var name: String
    public var attributes: [String: String] = [:]
    public var content: String = ""
    
    public var children: [AtomXMLNode] = []
    
    init(
        name: String,
        attributes: [String : String] = [:],
        content: String = "",
        children: [AtomXMLNode] = []
    ) {
        self.name = name
        self.attributes = attributes
        self.content = content
        self.children = children
    }
}

extension AtomXMLNode {
    public func childNode(name: String) -> AtomXMLNode? {
        children.first(where: { $0.name == name })
    }
    
    public func childNodes(name: String) -> [AtomXMLNode] {
        children.filter({ $0.name == name })
    }
}
