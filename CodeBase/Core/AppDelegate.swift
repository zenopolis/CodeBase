//
//  AppDelegate.swift
//  CodeBase
//
//  Created by David Kennedy on 27/06/2025.
//

import UIKit
import os.log

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Static Properties
    
    static let BundleIdentifier = Bundle.main.bundleIdentifier ?? "com.zenopolis.CodeBase"
    
    static let ApplicationSupportDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent(AppDelegate.BundleIdentifier, isDirectory: true).absoluteURL
    
    static let CacheFileURL = AppDelegate.ApplicationSupportDirectory.appendingPathComponent("state", isDirectory: false).absoluteURL

    // MARK: Data Access
    
    var persistance = Persistance()

    // MARK: Delegate Methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let fileManager = FileManager.default
        
        do {
            try fileManager.createDirectory(at: AppDelegate.ApplicationSupportDirectory, withIntermediateDirectories: true)
        } catch {
            os_log("Application support directory %{PRIVATE}@ does not exist: %{PUBLIC}@", log: OSLog.persistance, type: .error, AppDelegate.ApplicationSupportDirectory.path, error.localizedDescription)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

// MARK: - OSLog Extension

extension OSLog {
    
    private static var subsystem = AppDelegate.BundleIdentifier
    
    static let persistance = OSLog(subsystem: subsystem, category: "persistance")
}

