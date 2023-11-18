# AtomXML

This is a simple package for parsing XML files, build on top of Apple's [`XMLParser`](https://developer.apple.com/documentation/foundation/xmlparser)

## Usage

To parse an XML file, create an instance of the parser with the XML file. Then call its `parse` method.

```swift
let xmlData = getXmlData()

let parser = try AtomXMLParser(data: xmlData)
let tree = try parser.parse()
```

This will give you the root node of the XML tree. Each node in this tree, including the root node, will be of type `AtomXMLNode`. This type has the following properties:
- `name`: The name of the element, i.e. the text between the angle brackets.
- `attributes`: Custom attributes defined on this element, if any.
- `contents`: Text contents within this element, if any. If no text contents exist, or if this element wraps other elements, this property will be set to an empty string.
- `children`: Child elements of this element, if any. If this element has no children, or instead wraps text, this property will be set to an empty array.

In addition each node exposes a method for quickly finding and filtering child elements by name. The two methods are `childNode(name:)` for the first matched child and `childNodes(name:)` for all matching children.
