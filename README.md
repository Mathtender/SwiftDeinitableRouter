# SwiftDeinitableRouter
Easy-to-clean router.

When we have an architecture which uses some kind of a router we can face a problem that when the flow ends in some way(we return user to the screen before the flow, user decides to leave the flow manualy, etc.) the router object hanging as a dead weight. Code in this repo can help deinit those router objects.

General idea is save `weak` link on a controller(`anchorController`) that was in the stack before entering the flow, observe changes in `viewControllers` array in `UINavigationController` and then check wheather `anchorController` is `nil` or is equal to `viewControllers.last`, if so it means user has ended the flow and we can delete the router object.

There are 2 options of tracking changes in `viewControllers` array:
1) Using `MainNavigationController.swift` with overriden naviagation methods.
2) Using `UINavigationController+NavSwizzlingEx.swift` with swizzled navigation methods.
The second option is a bit incomplete because you have to track assertions to `viewControllers` yourself e.g. add `didSet` in your subclass and post notification with updated controllers, so the first option is more preferable.

Example of usage.

User `Router` as a parent class to create your own router:
```
class TestRouter: Router {

    // MARK: - Routing

    func startRouting() {
        // Set anchor controller before routing
        self.setAnchorController()

        // Make some routing
        NavigationCenter.sh.mainNavigationController.pushViewController(UIViewController(), animated: true)
    }

    override func endRouting() {
        // Close files, send events, etc
    }
}
```

Then make some class that will start routing:
```
class Main {

    // MARK: - Properties

    private var testRouter: TestRouter?

    // MARK: - Initialization

    init() {
        testRouter = TestRouter(routingEndedAction: { [weak self] in
            guard let self = self else {
                return
            }
            self.testRouter = nil
        })
    }

    // MARK: - Start routing

    func openSomeFeature() {
        testRouter?.startRouting()
    }
}
```
