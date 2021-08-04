//
//  Router.swift
//  SwiftDeinitableRouter
//
//  Created by Mathtender on 4.08.21.
//

class Router {

    // MARK: - Properties

    // Storing the weak link of the controller that was last in stack before our routings began
    // This will help us understand whether we can make further routing or not
    private weak var anchorController: UIViewController?

    private let routingEndedAction: (() -> Void)

    // MARK: - Initialization

    /// Creates a router.
    ///
    /// - Parameters:
    ///   - routingEndedAction: The action that got called when routing ends.
    required init(routingEndedAction: @escaping (() -> Void)) {
        self.routingEndedAction = routingEndedAction

        NavigationCenter.sh.navigationNotificationCenter.addObserver(
            self,
            selector: #selector(checkRoutingPossibility),
            name: MainNavigationController.viewControllersChangedNotificationName,
            object: NavigationCenter.sh.mainNavigationController)
    }

    // MARK: - Deinitialization

    deinit {
        NavigationCenter.sh.navigationNotificationCenter.removeObserver(
            self,
            name: MainNavigationController.viewControllersChangedNotificationName,
            object: NavigationCenter.sh.mainNavigationController)
    }

    // MARK: - Methods

    @objc private func checkRoutingPossibility(_ notification: Notification) {
        guard let viewControllers = notification.userInfo?["viewControllers"] as? [UIViewController] else {
            return
        }

        // End routing if anchor controller got closed
        // Or all controllers that we've oppend during the roting got closed
        if anchorController == nil || viewControllers.last === anchorController {
            endRouting()
            routingEndedAction()
        }
    }

    /// Sets anchor controller.
    ///
    /// - Parameters:
    ///   - controller: The anchor controller for the router.
    ///   If parameter is `nil` as an anchor will be used last controller from the `mainNavigationController` view controllers
    public func setAnchorController(_ controller: UIViewController? = nil) {
        if let controller = controller {
            anchorController = controller
        } else {
            anchorController = NavigationCenter.sh.mainNavigationController.viewControllers.last
        }
    }

    /// Called before `routingEndedAction`
    /// Use this method to clean the rotuer.
    public func endRouting() {}
}
