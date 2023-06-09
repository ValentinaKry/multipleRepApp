import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let networkManager = NetworkManager()
        let repoNC = UINavigationController(rootViewController: MainRepositoryViewController(viewModel: RepositopyListViewModel(networkManager: networkManager)))
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = repoNC
        return true
    }

    
}


