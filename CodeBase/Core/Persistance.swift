//
//  State.swift
//  CodeBase
//
//  Created by David Kennedy on 17/07/2025.
//

import Foundation

class Persistance: Codable {
        
    var selectedItem: Item? = nil
    
    private var openItems: Set<String> = []
    
    func setExpandedItem(_ item: Item) {
        openItems.insert(item.id)
    }
    
    func setCollapsedItem(_ item: Item) {
        openItems.remove(item.id)
    }
    
    func isExpanded(_ item: Item) -> Bool {
        return openItems.contains(item.id)
    }
        
}

extension Persistance: CustomStringConvertible {
    
    
    var description: String {
        """
        {
           openItems: \(openItems)
           selectedItem: \(selectedItem?.id ?? "{nil}")
        }
        """
    }
}
