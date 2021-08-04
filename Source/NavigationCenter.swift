//
//  NavigationCenter.swift
//  SwiftDeinitableRouter
//
//  Created by Mathtender on 4.08.21.
//

class NavigationCenter {

    // MARK: - Properties

    // Using a singleton pattern
    // Because we want to be able to navigate through our app's screens during the entire life of the app
    // And we want to have only one instance of `NavigationCenter`, so that it's responsible for the all navigation in the app
    static let sh = NavigationCenter()

    // We want to have our own notification center for posting only navigation notifications
    // Because we don't want to overload the `default` notification center
    let navigationNotificationCenter: NotificationCenter

    // Main controller that will be used for navigation through the app
    let mainNavigationController: MainNavigationController

    // MARK: - Initialization

    private init() {
        navigationNotificationCenter = NotificationCenter()
        mainNavigationController = MainNavigationController()
    }
}
