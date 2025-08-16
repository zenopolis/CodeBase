//
//  OutlineViewController+CollectionViewDelegate.swift
//  CodeBase
//
//  Created by David Kennedy on 24/03/2025.
//

import UIKit
import SafariServices

// MARK: OutlineViewController CollectionViewDelegate

extension OutlineViewController: UICollectionViewDelegate {
    
    // MARK: - Split View
    
    /// Returns `true` if the splitViewController wants active outline cells to display a detail indecator.
    internal func splitViewWantsToShowDetail() -> Bool {
        return splitViewController?.traitCollection.horizontalSizeClass == .regular
    }
    
    // MARK: - Managing Selected Cells
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        appDelegate.persistance.selectedItem = item
        collectionView.deselectItem(at: indexPath, animated: true)
        
        select(item: item)
    }
    
    func select(item: Item) {
        
        func macNavigation(title: String) {
            if navigationController!.traitCollection.userInterfaceIdiom == .mac {
                if let windowScene = view.window?.windowScene {
                    if #available(iOS 15, *) {
                        windowScene.subtitle = title
                    }
                }
            }
        }

        if let link = item.link {
            
            let file = link.file
            
            switch link.type {
                
            case .storyboard:
                selectStoryboard(name: file)
            case .https:
                selectWebpage(url: file)
            case .markdown:
                selectMarkdown(filename: file)
            }
        }
                        
        func selectStoryboard(name: String) {
            launchStoryboard(storyboardName: name)
            macNavigation(title: item.title)
        }
        
        func selectWebpage(url: String) {
            launchWebpage(url: url)
        }
        
        func selectMarkdown(filename: String) {
            launchMarkdown(filename: filename)
            macNavigation(title: item.title)
        }

    }
        
    // MARK: - Launchers

    private func launchStoryboard(storyboardName: String) {
        
        let exampleStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        if let exampleViewController = exampleStoryboard.instantiateInitialViewController() {
            displayViewController(viewController: exampleViewController)
        }
    }
    
    private func launchWebpage(url: String) {
        
        if let url = URL(string: url) {
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true)
        }
    }
    
    private func launchMarkdown(filename: String) {
        
        let markdownStoryboard = UIStoryboard(name: "MarkdownLaunchController", bundle: nil)
        if let markdownLaunchController = markdownStoryboard.instantiateInitialViewController() as? MarkdownLaunchController {
            markdownLaunchController.markdownFileName = filename
            displayViewController(viewController: markdownLaunchController)
        }
        
    }
    
    // MARK: - Private Helper Methods
    
    private func displayViewController(viewController: UIViewController) {
        
        if splitViewWantsToShowDetail() {
            
            let navigationViewController = UINavigationController(rootViewController: viewController)
            splitViewController?.showDetailViewController(navigationViewController, sender: navigationViewController) // Replace the detail view controller.
            
            if navigationController!.traitCollection.userInterfaceIdiom == .mac {
                navigationViewController.navigationBar.isHidden = true
            }
            
        } else {
            navigationController?.pushViewController(viewController, animated: true) // Just push instead of replace.
        }
    }
    
}

