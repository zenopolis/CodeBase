//
//  OutlineViewController.swift
//  CodeBase
//
//  Created by David Kennedy on 24/03/2025.
//

import UIKit

// MARK: OutlineViewController Main

class OutlineViewController: UIViewController {
    
    let showHelp = true

    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    var outlineCollectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @OutlineItemBuilder var items: [Item] {
        
        // TODO: Add example items here
    }
    
}

