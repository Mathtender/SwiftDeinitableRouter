# SwiftDeinitableRouter
Easy-to-clean router.

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
