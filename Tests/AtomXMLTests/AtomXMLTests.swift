import XCTest
@testable import AtomXML

final class AtomXMLTests: XCTestCase {
    func test_parsesSelfClosingNode() throws {
        let xml = """
        <?xml version="1.0" encoding="utf-8"?>
        <root/>
        """
        
        let parser = try AtomXMLParser(string: xml)
        let node = try parser.parse()
        
        let expectedNode = AtomXMLNode(name: "root", path: ["root"])
        
        XCTAssertEqual(node, expectedNode)
    }
     
//     func test_selfClosingNodeNameIsLowercase() throws {
//         let xml = """
//         <?xml version="1.0" encoding="utf-8"?>
//         <roOt/>
//         """
//
//         let parser = try AtomXMLParser(string: xml)
//         let node = try parser.parse()
//
//         XCTAssertEqual(node.name, "root")
//     }
    
    func test_parsesSelfClosingNode_withAttributes() throws {
        let xml = """
        <?xml version="1.0" encoding="utf-8"?>
        <root attr1="value1" attr2="value2"/>
        """
        
        let parser = try AtomXMLParser(string: xml)
        let node = try parser.parse()
        
        let expectedNode = AtomXMLNode(
            name: "root",
            attributes: [
                "attr1": "value1",
                "attr2": "value2",
            ],
            path: ["root"]
        )
        
        XCTAssertEqual(node, expectedNode)
    }
    
    func test_parsesNode() throws {
        let xml = """
        <?xml version="1.0" encoding="utf-8"?>
        <root></root>
        """
        
        let parser = try AtomXMLParser(string: xml)
        let node = try parser.parse()
        
        let expectedNode = AtomXMLNode(name: "root", path: ["root"])
        
        XCTAssertEqual(node, expectedNode)
    }
     
//     func test_nodeNameIsLowercase() throws {
//         let xml = """
//         <?xml version="1.0" encoding="utf-8"?>
//         <rOot></rOot>
//         """
//
//         let parser = try AtomXMLParser(string: xml)
//         let node = try parser.parse()
//
//         XCTAssertEqual(node.name, "root")
//     }
    
    func test_parsesNode_trimsNewLine_whenNodeNotOnSameLine() throws {
        let xml = """
        <?xml version="1.0" encoding="utf-8"?>
        <root>
        </root>
        """
        
        let parser = try AtomXMLParser(string: xml)
        let node = try parser.parse()
        
        let expectedNode = AtomXMLNode(name: "root", path: ["root"])
        
        XCTAssertEqual(node, expectedNode)
    }
    
    func test_parsesNode_withAttributes() throws {
        let xml = """
        <?xml version="1.0" encoding="utf-8"?>
        <root attr1="value1" attr2="value2"></root>
        """
        
        let parser = try AtomXMLParser(string: xml)
        let node = try parser.parse()
        
        let expectedNode = AtomXMLNode(
            name: "root",
            attributes: [
                "attr1": "value1",
                "attr2": "value2",
            ],
            path: ["root"]
        )
        
        XCTAssertEqual(node, expectedNode)
    }
    
    func test_parsesNode_withContent() throws {
        let xml = """
        <?xml version="1.0" encoding="utf-8"?>
        <root>This is content</root>
        """
        
        let parser = try AtomXMLParser(string: xml)
        let node = try parser.parse()
        
        let expectedNode = AtomXMLNode(
            name: "root",
            content: "This is content",
            path: ["root"]
        )
        
        XCTAssertEqual(node, expectedNode)
    }
    
    func test_parsesNode_withContentAndAttributes() throws {
        let xml = """
        <?xml version="1.0" encoding="utf-8"?>
        <root attr1="value1" attr2="value2">This is content</root>
        """
        
        let parser = try AtomXMLParser(string: xml)
        let node = try parser.parse()
        
        let expectedNode = AtomXMLNode(
            name: "root",
            attributes: [
                "attr1": "value1",
                "attr2": "value2",
            ],
            content: "This is content",
            path: ["root"]
        )
        
        XCTAssertEqual(node, expectedNode)
    }
    
    func test_parsesChildren_oneLevelDeep() throws {
        let xml = """
        <?xml version="1.0" encoding="utf-8"?>
        <root>
            <child></child>
            <child />
        </root>
        """
        
        let parser = try AtomXMLParser(string: xml)
        let node = try parser.parse()
        
        let expectedNode = AtomXMLNode(
            name: "root",
            path: ["root"],
            children: [
                AtomXMLNode(name: "child", path: ["root", "child"]),
                AtomXMLNode(name: "child", path: ["root", "child"]),
            ]
        )
        
        XCTAssertEqual(node, expectedNode)
    }
    
    func test_parsesChildren_withAttributes_oneLevelDeep() throws {
        let xml = """
        <?xml version="1.0" encoding="utf-8"?>
        <root>
            <child attr1="value1"></child>
            <child attr2="value2"/>
        </root>
        """
        
        let parser = try AtomXMLParser(string: xml)
        let node = try parser.parse()
        
        let expectedNode = AtomXMLNode(
            name: "root",
            path: ["root"],
            children: [
                AtomXMLNode(
                    name: "child",
                    attributes: [
                        "attr1": "value1",
                    ],
                    path: ["root", "child"]
                ),
                AtomXMLNode(
                    name: "child",
                    attributes: [
                        "attr2": "value2",
                    ],
                    path: ["root", "child"]
                ),
            ]
        )
        
        XCTAssertEqual(node, expectedNode)
    }
    
    func test_parsesChildren_withContent_oneLevelDeep() throws {
        let xml = """
        <?xml version="1.0" encoding="utf-8"?>
        <root>
            <child>This is content</child>
            <child />
        </root>
        """
        
        let parser = try AtomXMLParser(string: xml)
        let node = try parser.parse()
        
        let expectedNode = AtomXMLNode(
            name: "root",
            path: ["root"],
            children: [
                AtomXMLNode(name: "child", content: "This is content", path: ["root", "child"]),
                AtomXMLNode(name: "child", path: ["root", "child"]),
            ]
        )
        
        XCTAssertEqual(node, expectedNode)
    }
    
    func test_parsesChildren_withContentAndAttributes_oneLevelDeep() throws {
        let xml = """
        <?xml version="1.0" encoding="utf-8"?>
        <root>
            <child>This is content</child>
            <child attr="value"/>
        </root>
        """
        
        let parser = try AtomXMLParser(string: xml)
        let node = try parser.parse()
        
        let expectedNode = AtomXMLNode(
            name: "root",
            path: ["root"],
            children: [
                AtomXMLNode(name: "child", content: "This is content", path: ["root", "child"]),
                AtomXMLNode(
                    name: "child",
                    attributes: [
                        "attr": "value",
                    ],
                    path: ["root", "child"]
                ),
            ]
        )
        
        XCTAssertEqual(node, expectedNode)
    }
     
     func test_parsesCData() throws {
         let xml = """
         <?xml version="1.0" encoding="utf-8"?>
         <root><![CDATA[SwiftData]]></root>
         """
         
         let parser = try AtomXMLParser(string: xml)
         let node = try parser.parse()
         
         let expectedNode = AtomXMLNode(
             name: "root",
             content: "SwiftData",
             path: ["root"]
         )
         
         XCTAssertEqual(node, expectedNode)
     }
     
     func test_parsesMultilineCData() throws {
         let xml = """
         <?xml version="1.0" encoding="utf-8"?>
         <root>
            <![CDATA[SwiftData]]>
         </root>
         """
         
         let parser = try AtomXMLParser(string: xml)
         let node = try parser.parse()
         
         let expectedNode = AtomXMLNode(
             name: "root",
             content: "SwiftData",
             path: ["root"]
         )
         
         XCTAssertEqual(node, expectedNode)
     }
     func test_parsesMultilineCData2() throws {
         let xml = """
         <?xml version="1.0" encoding="utf-8"?>
         <root>
         <![CDATA[Paragraph one.
         
         Paragraph two.
         
         <span class="s-keyword">var</span> text: <span class="s-type">String</span>
         
         Another paragraph[&#8230;]]]>
         </root>
         """
         
         let parser = try AtomXMLParser(string: xml)
         let node = try parser.parse()
         
         let expectedNode = AtomXMLNode(
             name: "root",
             content: """
             Paragraph one.
             
             Paragraph two.
             
             <span class="s-keyword">var</span> text: <span class="s-type">String</span>
             
             Another paragraph[&#8230;]
             """,
             path: ["root"]
         )
         
         dump(node)
         dump(expectedNode)
         
         XCTAssertEqual(node, expectedNode)
     }
    
    func test_parsesPath() throws {
        let xml = """
        <?xml version="1.0" encoding="utf-8"?>
        <root>
            <child>This is content</child>
            <child>
                <subchild>
                    <subsubchild />
                    <subsubchild />
                </subchild>
            </child>
        </root>
        """
        
        let parser = try AtomXMLParser(string: xml)
        let node = try parser.parse()
        
        let expectedNode = AtomXMLNode(
            name: "root",
            path: ["root"],
            children: [
                AtomXMLNode(name: "child", content: "This is content", path: ["root", "child"]),
                AtomXMLNode(
                    name: "child",
                    path: ["root", "child"],
                    children: [
                        AtomXMLNode(
                            name: "subchild",
                            path: ["root", "child", "subchild"],
                            children: [
                                AtomXMLNode(name: "subsubchild", path: ["root", "child", "subchild", "subsubchild"]),
                                AtomXMLNode(name: "subsubchild", path: ["root", "child", "subchild", "subsubchild"]),
                            ]
                        )
                    ]
                ),
            ]
        )
        
        XCTAssertEqual(node, expectedNode)
    }
}

extension AtomXMLNode: Equatable {
    public static func ==(_ lhs: Self, _ rhs: Self) -> Bool {
        lhs.name == rhs.name
        && lhs.attributes == rhs.attributes
        && lhs.content == rhs.content
        && lhs.content == rhs.content
    }
}
