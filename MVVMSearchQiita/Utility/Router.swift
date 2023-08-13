

import UIKit
// 画面遷移を担うクラスでシングルトン
final class Router {
    // static let shared = Router()を丁寧に書くとこうなる
    static let shared: Router = .init()
    private init() {}

    // インスタンスを保持するためのプロパティ
    internal var loginViewController: LoginViewController?

    // 起動経路
    internal func showRoot(windowScene: UIWindowScene) -> UIWindow?{
        let window = UIWindow(windowScene: windowScene)
        guard let vc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as? LoginViewController else {
            return nil
        }
        // presenterとvcを繋ぐ
        let presenter = LoginPresenter(output: vc)
        vc.inject(presenter: presenter)

        self.loginViewController = vc
        let nav = UINavigationController(rootViewController: vc)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        return window
    }

    // Searchに遷移
    internal func showSearch(from: UIViewController) {
        guard let toVC = UIStoryboard(name: "Search", bundle: nil).instantiateInitialViewController() as? SearchViewController else { return }
        // presenterとvcを繋ぐ
        let presenter = SearchPresenter(output: toVC)
        toVC.inject(presenter: presenter)
        show(from: from, to: toVC)
    }

    // Webに遷移
    internal func showWeb(from: UIViewController, qiitaItemModel: QiitaItemModel) {
        guard let toVC = UIStoryboard(name: "Web", bundle: nil).instantiateInitialViewController() as? WebViewController else { return }
        let presenter = WebPresenter(output: toVC, qiitaItem: qiitaItemModel)
        toVC.inject(presenter: presenter)
        show(from: from, to: toVC)
    }
}

private extension Router {
    // 基本の画面遷移メソッド、アニメーションはデフォルト引数でtrue
    func show(from: UIViewController, to: UIViewController, animated: Bool = true) {
        //　移動元がnavigationControllerだったら
        if let nav = from.navigationController {
            // プッシュ遷移
            nav.pushViewController(to, animated: animated)
        } else { // 違うのなら
            // モーダル遷移
            from.present(to, animated: animated)
        }
    }
}
