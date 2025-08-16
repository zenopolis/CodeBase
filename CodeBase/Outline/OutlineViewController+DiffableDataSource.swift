//
//  OutlineViewController+DiffableDataSource.swift
//  CodeBase
//
//  Created by David Kennedy on 24/03/2025.
//

import UIKit

// MARK: OutlineViewController DiffableDataSource

extension OutlineViewController {
    
    enum Section {
        case main
    }
    
    func configureDataSource() {
        
        let containerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = item.title
            
            contentConfiguration.image = UIImage(systemName: item.image)
            
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = contentConfiguration
            
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: disclosureOptions)]
            
            let background = UIBackgroundConfiguration.clear()
            cell.backgroundConfiguration = background
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, indexPath, item in
            
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = item.title
            
            contentConfiguration.image = UIImage(systemName: item.image)
            
            cell.contentConfiguration = contentConfiguration
            
            let background = UIBackgroundConfiguration.clear()
            cell.backgroundConfiguration = background
            
            cell.accessories = self.splitViewWantsToShowDetail() ? [] : [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: outlineCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            
            // Return the cell.
            if item.subitems.isEmpty {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: containerCellRegistration, for: indexPath, item: item)
            }
        }
                
        dataSource.sectionSnapshotHandlers.willExpandItem = { item in
            self.appDelegate.persistance.setExpandedItem(item)
        }

        dataSource.sectionSnapshotHandlers.willCollapseItem = { item in
            self.appDelegate.persistance.setCollapsedItem(item)
        }
        
        // Load our initial data.
        let snapshot = initialSnapshot()
        self.dataSource.apply(snapshot, to: .main, animatingDifferences: false)
        
        // Select persistant selected item if it still exists.
        if let selectedItem = appDelegate.persistance.selectedItem {
            
            let itemIDs = snapshot.items.map { $0.id }

            if itemIDs.contains(selectedItem.id) {
                select(item: selectedItem)
            }
        }
        
        validate(items: items)
    }
    
    private func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<Item> {
        
        var snapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        
        var itemsWithUnrecognizedLinks: [Item] = []
        
        func addItems(_ items: [Item], to parent: Item?) {
            snapshot.append(items, to: parent)
            if let parent, appDelegate.persistance.isExpanded(parent) {
                snapshot.expand([parent])
            }
            for item in items where !item.subitems.isEmpty {
                addItems(item.subitems, to: item)
                if item.link == nil {
                    itemsWithUnrecognizedLinks.append(item)
                }
            }
        }
        
        addItems(items, to: nil)
        if showHelp { addItems(helpItems, to: nil) }
        return snapshot
    }
    
    private func validate(items: [Item]) {
        
        func validate(items: [Item]) -> [Item] {
            
            var badItems: [Item] = []

            for item in items {
                if let link = item.link {
                    if !link.isValid {
                        badItems.append(item)
                    }
                } else {
                    let subitems = item.subitems
                    let subBad = validate(items: subitems)
                    if !subBad.isEmpty {
                        badItems.append(contentsOf: subBad)
                    }
                }
            }
            return badItems
        }
        
        let baditems = validate(items: items)
        if !baditems.isEmpty {
            print("Bad Items...")
            for item in baditems {
                print("\(item)  Error: \(item.link!.error!.localizedDescription)")
            }
        }
    }
    
    private func reportUnrecognizedLinks(items: [Item]) {
        
        guard !items.isEmpty else { return }
        
        print("Items with unrecognised links:")
        for item in items {
            print("\(item)")
        }
    }
    
}

