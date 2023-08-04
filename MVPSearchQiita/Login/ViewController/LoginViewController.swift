
import UIKit
import Lottie

/// ログイン画面
final class LoginViewController: UIViewController {
    /// Lottieをインスタンス化
    private let animationView = LottieAnimationView()
    /// アニメーションを入れるコンテナビュー
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            guard let animation = LottieAnimation.named("login", subdirectory: nil) else {
                print("\(#line) file not found")
                return
            }
            animationView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(animationView)
            NSLayoutConstraint.activate([
                animationView.topAnchor.constraint(equalTo: containerView.topAnchor),
                animationView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                animationView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                animationView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            ])
            // アニメーションの設定
            animationView.animation = animation
            // アニメーションをループ再生に設定
            animationView.loopMode = .loop
            // アニメーション実行を設定
            animationView.play()
        }
    }
    /// ログインしないで検索画面に移動するボタン
    @IBOutlet private weak var nonLoginButton: UIButton! {
        didSet {
            nonLoginButton.addTarget(self, action: #selector(nonLoginButtonTapped), for: .touchUpInside)
        }
    }
    /// ログインボタン、認証認可処理の開始
    @IBOutlet private weak var loginButton: UIButton! {
        didSet {
            loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 接続用のプロパティとメソッド
    private var presenter: LoginPresenterInput!
    func inject(presenter: LoginPresenterInput) {
        self.presenter = presenter
    }

    /// リダイレクトされたら認可コードを受け取り、保存する
    ///  検索画面に遷移する
    internal func openURL(_ url: URL) {
        self.presenter.reDirect(url)
    }
    /// 認証画面へ遷移して認証処理の開始
    @objc private func loginButtonTapped() {
        print("ログイン処理の開始")
        self.presenter.login()
    }

    /// 認証処理をせずに検索画面に遷移
    @objc private func nonLoginButtonTapped() {
        print("ログイン処理の開始")
        self.presenter.nonLogin()
    }
}

extension LoginViewController: LoginPresenterOutput {
    func openOAuthURL() {
        UIApplication.shared.open(QiitaAPI.shared.oAuthURL)
    }

    func showSearch() {
        Router.shared.showSearch(from: self)
    }

    func get(error: Error) {
        print(error.localizedDescription)
    }
}
