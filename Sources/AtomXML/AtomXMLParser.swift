import Foundation

public final class AtomXMLParser: NSObject {
    public enum Error: Swift.Error {
        case unableToReadURL
        case unableToReadString
        case failedToParse
    }
    
    private let parser: XMLParser
    
    private(set) var tree: AtomXMLNode?
    private var stack: [AtomXMLNode] = []
    
    private var accumulatedContent: [String] = []
    
    private var topStackNode: AtomXMLNode? {
        get { stack.last }
        set {
            if let newValue {
                stack[stack.endIndex - 1] = newValue
            } else {
                stack.removeLast()
            }
        }
    }
    
    public init(contentsOf url: URL) throws {
        guard let parser = XMLParser(contentsOf: url) else {
            throw Error.unableToReadURL
        }
        
        self.parser = parser
        super.init()
        self.parser.delegate = self
    }
    
    public init(data: Data) {
        parser = XMLParser(data: data)
        super.init()
        parser.delegate = self
    }
    
    public convenience init(string: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw Error.unableToReadString
        }
        self.init(data: data)
    }
    
    public func parse() throws -> AtomXMLNode {
        guard parser.parse(), let tree else { throw Error.failedToParse }
        
        return tree
    }
}



extension AtomXMLParser: XMLParserDelegate {
    public func parserDidStartDocument(_ parser: XMLParser) {
        resetState()
    }
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//        print("Parsing \(elementName), attributes: \(attributeDict)")
        startNewNode(name: elementName, attributes: attributeDict)
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        addAccumulatedContent(string)
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        assert(elementName == topStackNode?.name)
        
        assignAccumulatedStringToTopNode()
        popTopNode()
    }

    
    // MARK: Helpers
    
    private func resetState() {
        tree = nil
        stack = []
        resetAccumulatedContent()
    }
    
    private func resetAccumulatedContent() {
        accumulatedContent = []
    }
    
    private func startNewNode(name: String, attributes: [String: String]) {
        resetAccumulatedContent()
        let newNode = AtomXMLNode(name: name, attributes: attributes)
        stack.append(newNode)
    }
    
    private func addAccumulatedContent(_ content: String) {
        accumulatedContent.append(content)
    }
    
    private func assignAccumulatedStringToTopNode() {
        topStackNode?.content = accumulatedContent
            .joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        resetAccumulatedContent()
    }
    
    private func popTopNode() {
        let node = stack.removeLast()
        
        if stack.isEmpty {
            tree = node
        } else {
            topStackNode?.children.append(node)
        }
    }
}
