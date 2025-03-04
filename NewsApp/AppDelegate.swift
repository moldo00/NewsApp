import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = createTabBarController()
        window?.makeKeyAndVisible()
        return true
    }

    private func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()

        let allNewsVC = AllNewsViewController()
        allNewsVC.tabBarItem = UITabBarItem(title: "Все новости", image: UIImage(systemName: "list.bullet"), tag: 0)

        let favoriteNewsVC = FavoriteNewsViewController()
        favoriteNewsVC.tabBarItem = UITabBarItem(title: "Избранное", image: UIImage(systemName: "star.fill"), tag: 1)

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        tabBarController.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }

        tabBarController.viewControllers = [allNewsVC, favoriteNewsVC]
        return tabBarController
    }
}
