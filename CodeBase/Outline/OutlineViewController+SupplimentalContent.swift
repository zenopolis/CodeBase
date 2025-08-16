//
//  OutlineViewController+SupplimentalContent.swift
//  CodeBase
//
//  Created by David Kennedy on 10/08/2025.
//

import UIKit

// MARK: OutlineViewController SupplimentalContent

extension OutlineViewController {
    
    @OutlineItemBuilder var helpItems: [Item] {

        Item(image: "questionmark.circle", title: "Help") {
            Item(title: "Setup", linkType: .markdown, file: "Setup")
            Item(title: "Adding Your Examples", linkType: .markdown, file: "Adding Your Examples")
        }
    }

}
