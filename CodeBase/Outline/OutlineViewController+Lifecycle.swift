//
//  OutlineViewController+Lifecycle.swift
//  CodeBase
//
//  Created by David Kennedy on 19/07/2025.
//

import UIKit

// MARK: OutlineViewController Lifecycle

extension OutlineViewController {
    
    // MARK: Setup and Configuration
    
    func setup() {
        
        configureCollectionView()
        configureDataSource()
        
        // Set the Mac PrimaryViewController background to clear
        splitViewController!.primaryBackgroundStyle = .sidebar
        view.backgroundColor = UIColor.clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDetailTargetDidChange(notification:)), name: UIViewController.showDetailTargetDidChangeNotification, object: nil)
        
        if navigationController!.traitCollection.userInterfaceIdiom == .mac {
            navigationController!.navigationBar.isHidden = true
        }
    }
    
    private func configureCollectionView() {
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.outlineCollectionView = collectionView
        collectionView.delegate = self
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let listconfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        let layout = UICollectionViewCompositionalLayout.list(using: listconfiguration)
        return layout
    }

    // MARK: Notifications
    
    /// Recieved  when a split view controller is expanded or collapsed.
    @objc private func showDetailTargetDidChange(notification: NSNotification) {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
