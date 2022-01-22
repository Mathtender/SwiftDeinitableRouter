//
//  MainNavigationController.swift
//  SwiftDeinitableRouter
//
//  Created by Mathtender on 23.01.22.
//

extension UINavigationController {

    // MARK: - Swizzling

    // Call this method in AppDelegate's application(_:didFinishLaunchingWithOptions:)
    static func swizzleNavigaitonMethods() {
        swizzle(originalSelector: #selector(self.pushViewController(_:animated:)),
                swizzledSelector: #selector(self.swizzled_pushViewController(viewController:animated:)))
        swizzle(originalSelector: #selector(self.setViewControllers(_:animated:)),
                swizzledSelector: #selector(self.swizzled_setViewControllers(viewControllers:animated:)))
        swizzle(originalSelector: #selector(self.setViewControllers(_:animated:)),
                swizzledSelector: #selector(self.swizzled_setViewControllers(viewControllers:animated:)))
        swizzle(originalSelector: #selector(self.popViewController(animated:)),
                swizzledSelector: #selector(self.swizzled_popViewController(animated:)))
        swizzle(originalSelector: #selector(self.popToViewController(_:animated:)),
                swizzledSelector: #selector(self.swizzled_popToViewController(viewController:animated:)))
        swizzle(originalSelector: #selector(self.popToRootViewController(animated:)),
                swizzledSelector: #selector(self.swizzled_popToRootViewController(animated:)))
    }

    private static func swizzle(originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(UINavigationController.self, originalSelector)!
        let swizzledMethod = class_getInstanceMethod(UINavigationController.self, swizzledSelector)!
        if class_addMethod(UINavigationController.self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) {
            class_replaceMethod(UINavigationController.self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }

    // MARK: - Swizzled methods

    @objc func swizzled_pushViewController(viewController: UIViewController, animated: Bool) {
        postControllersChangedNotificaiton(viewControllers + [viewController])
        swizzled_pushViewController(viewController: viewController, animated: animated)
    }

    @objc func swizzled_setViewControllers(viewControllers: [UIViewController], animated: Bool) {
        swizzled_setViewControllers(viewControllers: viewControllers, animated: animated)
        postControllersChangedNotificaiton(viewControllers)
    }

    @objc func swizzled_popViewController(animated: Bool) {
        swizzled_popViewController(animated: animated)
        postControllersChangedNotificaiton(viewControllers)
    }

    @objc func swizzled_popToViewController(viewController: UIViewController, animated: Bool) {
        swizzled_popToViewController(viewController: viewController, animated: animated)
        postControllersChangedNotificaiton(viewControllers)
    }

    @objc func swizzled_popToRootViewController(animated: Bool) {
        swizzled_popToRootViewController(animated: animated)
        postControllersChangedNotificaiton(viewControllers)
    }

    // MARK: - Notification

    private func postControllersChangedNotificaiton(_ viewControllers: [UIViewController]) {
        NavigationCenter.sh.navigationNotificationCenter.post(
            name: NSNotification.Name("UINavigationControllerViewControllersChanged"),
            object: self,
            userInfo: ["viewControllers": viewControllers])
    }
}
