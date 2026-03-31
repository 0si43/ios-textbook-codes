import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        print("SceneDelegate called")
        guard let windowScene = scene as? UIWindowScene else { return }

        let apiClient = GitHubAPIClientImpl()
        let repository = UserRepositoryImpl(apiClient: apiClient)
        let viewModel = UserListViewModel(userRepository: repository)
        let userListVC = UserListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: userListVC)

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
