import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = createTabBarController()
        window?.makeKeyAndVisible()
    }

    private func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()

        let allNewsVC = UINavigationController(rootViewController: AllNewsViewController())
        allNewsVC.tabBarItem = UITabBarItem(title: "Все новости", image: UIImage(systemName: "list.bullet"), tag: 0)

        let favoriteNewsVC = UINavigationController(rootViewController: FavoriteNewsViewController())
        favoriteNewsVC.tabBarItem = UITabBarItem(title: "Избранное", image: UIImage(systemName: "star.fill"), tag: 1)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        allNewsVC.navigationBar.standardAppearance = appearance
        favoriteNewsVC.navigationBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            allNewsVC.navigationBar.scrollEdgeAppearance = appearance
            favoriteNewsVC.navigationBar.scrollEdgeAppearance = appearance
        }

        tabBarController.viewControllers = [allNewsVC, favoriteNewsVC]
        return tabBarController
    }
}
