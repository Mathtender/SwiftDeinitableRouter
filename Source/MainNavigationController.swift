//
//  MainNavigationController.swift
//  SwiftDeinitableRouter
//
//  Created by Mathtender on 4.08.21.
//

class MainNavigationController: UINavigationController, UINavigationControllerDelegate {

    // MARK: - Properties

    // Making notification name static so we could add an observer for it
    static let viewControllersChangedNotificationName = NSNotification.Name("MainNavigationControllerDidShowViewControllerNotification")

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    // MARK: - UINavigationControllerDelegate methods

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let notificationInfo = ["viewControllers": viewControllers]

        // Posting notification with current array of `viewControllers` so we could track the changes
        NavigationCenter.sh.navigationNotificationCenter.post(
            name: MainNavigationController.viewControllersChangedNotificationName,
            object: self,
            userInfo: notificationInfo)
    }
}
