//
//  Item.swift
//  CodeBase
//
//  Created by David Kennedy on 24/03/2025.
//

import Foundation

// MARK:  Item

final class Item: Identifiable, Codable {
    
    // MARK: Static values
    
    static let defaultUnknownImage = "questionmark.circle.dashed"
    static let disallowedFilenameCharacters = CharacterSet(charactersIn: "\"\\:/")

    // MARK: - LinkType
    
    enum LinkType: String {
        case storyboard = "storyboard"
        case https      = "https"
        case markdown   = "markdown"
    }

    // MARK: - Content
    
    enum Content: Codable {
        case link(Link)
        case items([Item])
        
        // MARK: - Link
        
        struct Link: Codable {
            
            enum ItemLinkError: LocalizedError {
                case missingFileName
                case httpsProtocolMissingFromFileName
                case incompatibleCharactersInFileName
                case colonMissingInLinkString
                case tooManyColonsInLinkString
                case invalidLinkType
                
                var errorDescription: String? {
                    switch self {
                    case .missingFileName:
                        return "File missing."
                    case .httpsProtocolMissingFromFileName:
                        return "\"https:\" missing from link."
                    case .incompatibleCharactersInFileName:
                        return "File contains unexpected characters."
                    case .colonMissingInLinkString:
                        return "Expected colon missing from link."
                    case .tooManyColonsInLinkString:
                        return "Too many colons in link (only one colon expected)."
                    case .invalidLinkType:
                        return "Link type unknown."
                    }
                }
            }
            
            var type: LinkType
            var file: String
            var error: ItemLinkError?
            
            var isValid: Bool {
                return error == nil
            }
                                        
            var identifier: String {
                switch type {
                case .https:
                    return file
                default:
                    return type.rawValue + ":" + file
                }
            }
            
            var defaultImage: String {
                
                switch type {
                case .storyboard:   return "app.dashed"
                case .https:        return "globe"
                case .markdown:     return "book"
                }
            }
            
            init(type: LinkType, file: String) {
                
                self.type = type
                self.file = file

                guard !file.isEmpty else { self.error = .missingFileName; return}
               
                switch type {
                case .https:
                    if !file.lowercased().hasPrefix("https:") { self.error = .httpsProtocolMissingFromFileName }
                default:
                    let fileContainsDisallowedCharacters = file.rangeOfCharacter(from: disallowedFilenameCharacters) != nil
                    if fileContainsDisallowedCharacters { self.error = .incompatibleCharactersInFileName }
                }
            }
            
            fileprivate init(_ value: String) throws {
                
                if value .hasPrefix("https:") {
                    self.init(type: .https, file: value)
                    return
                }
                
                let colonCount = value.filter { $0 == ":" }.count
                if colonCount == 0 { throw ItemLinkError.colonMissingInLinkString }
                if colonCount > 1 { throw ItemLinkError.tooManyColonsInLinkString }
                
                let components = value.components(separatedBy: ":")
                let typeStr = components[0]
                let fileStr = components[1]
                
                guard let linkType = LinkType(rawValue: typeStr) else { throw ItemLinkError.invalidLinkType }
                
                self.init(type: linkType, file: fileStr)
                if let error { throw error }
            }
            
            // MARK: Codable
            
            init(from decoder: any Decoder) throws {
                let container = try decoder.singleValueContainer()
                let stringValue = try container.decode(String.self)
                try self.init(stringValue)
            }

            func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch type {
                case .https:
                    try container.encode(self.file)
                default:
                    try container.encode(self.identifier)
                }
            }
            
        }
        
        // MARK: -
        
        init(from decoder: any Decoder) throws {
            
            if let container = try? decoder.singleValueContainer() {
                if let items = try? container.decode([Item].self) {
                    self = .items(items)
                    return
                } else if let content = try? container.decode(String?.self) {
                    try self = .link(Link(content))
                    return
                }
            }
            self = .items([])
        }
        
        func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .link(let content):
                try container.encode(content)
            case .items(let items):
                try container.encode(items)
            }
        }
    }
    
    // MARK: - Properties
    
    var id: String
    var image: String
    var title: String
    
    private var content: Content
    
    var link: Content.Link? {
        switch content {
        case .link(let link):
            return link
        default:
            return nil
        }
    }
    
    var subitems: [Item] {
        switch content {
        case .link:
            return []
        case .items(let items):
            return items
        }
    }
        
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.decode(String.self, forKey: .title)

        let content = try container.decode(Item.Content.self, forKey: .content)
        let image = try container.decodeIfPresent(String.self, forKey: .image)
                
        switch content {
        case .link(let link):
            if let image = image {
                self.image = image
            } else {
                self.image = link.defaultImage
            }
            self.id = link.identifier
        case .items(_):
            var imgName: String = ""
            if let image = image {
                imgName = image
            } else {
                imgName = Self.defaultUnknownImage
            }
            self.id = imgName + "+" + title
            self.image = imgName
        }

        self.content = content
    }
    
    init(image: String? = nil, title: String, linkType: LinkType, file: String) {
        
        let content = Content.Link(type: linkType, file: file)
        let identifier = content.identifier
                
        self.content = .link(content)
        
        var imageName = image ?? ""
        if imageName == "" { imageName = content.defaultImage }

        self.title = title
        self.image = imageName
        self.id = identifier
    }
        
    init(image: String? = nil, title: String, children: [Item]) {
                        
        var imageName = image ?? ""
        if imageName == "" { imageName = Self.defaultUnknownImage }

        self.title = title
        self.image = imageName
        self.id = imageName + "+" + title
        
        self.content = .items(children)
    }
    
    convenience init(image: String? = nil, title: String, @OutlineItemBuilder builder: () -> [Item]) {
        let children = builder()
        self.init(image: image, title: title, children: children)
    }
    
}

// MARK: - Hashable

extension Item: Hashable {
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

// MARK: - Custom String Convertible

extension Item.Content.Link: CustomStringConvertible {
    
    var description: String {
        
        var fileStr = ""

        switch type {
        case .https: break
        default:
            fileStr = " file: \"\(file)\","
        }
                
        return """
        <Content "\(identifier)", \(fileStr) type: .\(type)>
        """
    }
    
}

extension Item: CustomDebugStringConvertible {
    
    var debugDescription: String {
        
        var contentStr: String
        switch content {
        case .items(let items):  contentStr = " [\(items.count) child items]"
        case .link(let content): contentStr = content.description
        }
        
        return """
        <Item id: "\(id)"> {image: "\(image)", title: "\(title), content: \(contentStr)"}
        """
    }

}

// MARK: - Result Builder

@resultBuilder
struct OutlineItemBuilder {
    
    // Ref: https://www.avanderlee.com/swift/result-builders/
    
    /// Expects one or more OutlineItem arrays. Returns a single combined array.
    static func buildBlock(_ components: [Item]...) -> [Item] { components.flatMap { $0 } }
    
    /// Add support for both a single OutlineItem and an array of OutlineItems, always return OutlineItem array.
    static func buildExpression(_ outlineItem: Item) -> [Item] { [outlineItem] }
    static func buildExpression(_ outlineItems: [Item]) -> [Item] { outlineItems }
    
    /// Add support for optionals.
    static func buildOptional(_ outlineItems: [Item]?) -> [Item] { outlineItems ?? [] }
    
    /// Add support for if statements.
    static func buildEither(first outlineItems: [Item]) -> [Item] { outlineItems }
    static func buildEither(second outlineItems: [Item]) -> [Item] { outlineItems }
    
    /// Add support for #availability checks.
    static func buildLimitedAvailability(_ outlineItems: [Item]) -> [Item] { outlineItems }

}
