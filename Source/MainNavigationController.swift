//
//  MainNavigationController.swift
//  SwiftDeinitableRouter
//
//  Created by Mathtender on 4.08.21.
//

class MainNavigationController: UINavigationController {

    // MARK: - Properties

    static let viewControllersChangedNotificationName = NSNotification.Name("MainNavigationControllerViewControllersChanged")

    override var viewControllers: [UIViewController] {
        didSet { postControllersChangedNotificaiton(viewControllers) }
    }

    // MARK: - Notificaiton

    private func postControllersChangedNotificaiton(_ viewControllers: [UIViewController]) {
        NavigationCenter.sh.navigationNotificationCenter.post(
            name: MainNavigationController.viewControllersChangedNotificationName,
            object: self,
            userInfo: ["viewControllers": viewControllers])
    }

    // MARK: - Navigation

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        postControllersChangedNotificaiton(viewControllers + [viewController])
        super.pushViewController(viewController, animated: animated)
    }

    @discardableResult
    override func popViewController(animated: Bool) -> UIViewController? {
        let viewController = super.popViewController(animated: animated)
        postControllersChangedNotificaiton(viewControllers)
        return viewController
    }

    @discardableResult
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let poppedViewControllers = super.popToViewController(viewController, animated: animated)
        postControllersChangedNotificaiton(viewControllers)
        return poppedViewControllers
    }

    @discardableResult
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let poppedViewControllers = super.popToRootViewController(animated: animated)
        postControllersChangedNotificaiton(viewControllers)
        return poppedViewControllers
    }

    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        postControllersChangedNotificaiton(viewControllers)
        super.setViewControllers(viewControllers, animated: animated)
    }
}
