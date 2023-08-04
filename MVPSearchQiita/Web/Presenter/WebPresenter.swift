
import Foundation

/// 外から受け取るアクションのプロトコル
protocol WebPresenterInput {
    /// 画面を読み込んだことを受け取る
    /// 読み込まれたら前の画面から受け取った記事のURLを使って
    /// 読み込みをする
    func viewDidLoaded()
}

/// 外へ出すアクションのプロトコル
protocol WebPresenterOutput: AnyObject {
    /// 記事のurlを元に画面にロードするように伝える
    func webViewLoad(request: URLRequest)
}

/// プレゼンターを管理
final class WebPresenter {
    /// 外に出すprotocolに準拠したインスタンス（ViewControllerのこと）
    private weak var output:WebPresenterOutput!
    /// この中で変化するパラメーター
    private var qiitaItem: QiitaItemModel
    /// イニシャライザー
    init(output: WebPresenterOutput,qiitaItem: QiitaItemModel) {
        self.output = output
        self.qiitaItem = qiitaItem
    }
}

/// ViewControllerから指示を受けた際の処理
extension WebPresenter: WebPresenterInput {
    func viewDidLoaded() {
        guard
            let url = URL(string: qiitaItem.urlStr) else {
            return
        }
        //受け渡されたモデルのURLを表示する
        output.webViewLoad(request: URLRequest(url: url))
    }

}
