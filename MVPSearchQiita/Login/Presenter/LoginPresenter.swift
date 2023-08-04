//
//  LoginPresenter.swift
//  MVPSearchQiita
//
//  Created by 本川晴彦 on 2023/08/01.
//

import Foundation
// 外から受け付けるアクションのプロトコル
protocol LoginPresenterInput {
    // ログインボタン押された
    func login()
    // ログインしないで遷移するボタン押された
    func nonLogin()
    // リダイレクトされたことをしる
    func reDirect(_ url: URL)
}

// 外へ出すアクションのプロトコル
protocol LoginPresenterOutput: AnyObject {
    // ログインボタン押されたら、ログイン処理を開始してね
    func openOAuthURL()
    // ログインしないで遷移するボタン押された、遷移してねと伝える
    func showSearch()
    // エラーが出た時の処理
    func get(error: Error)
}

// プレゼンター
final class LoginPresenter {
    // 外に出すプロパティのインスタンス
    private weak var output: LoginPresenterOutput!

    private var qiitaAPI: QiitaAPIProtocol!

    init(output: LoginPresenterOutput!, qiitaAPI: QiitaAPIProtocol = QiitaAPI.shared) {
        self.output = output
        self.qiitaAPI = qiitaAPI
    }
}

extension LoginPresenter: LoginPresenterInput {
    /// リダイレクトされたら認可コードを受け取り、保存する
    ///  検索画面に遷移する
    func reDirect(_ url: URL) {
        // 引数urlからクエリストリングに含まれるキーバリューペアの配列を取得
        guard let queryItems = URLComponents(string: url.absoluteString)?.queryItems,
              // "code"に該当するキーバリューペアを検索して取得 <- これが認可コード
              let code = queryItems.first(where: { $0.name == "code" })?.value,
              // "state"に該当するキーバリューペアを検索して取得
              let getState = queryItems.first(where: { $0.name == "state" })?.value,
              // getStateが指定したStateと同一かチェック
              getState == qiitaAPI.qiitaState
        else {
            return
        }
        // 認可コードを受け取り、トークンを保存
        QiitaAPI.shared.postAccessToken(code: code) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let accessToken):
                    // アクセストークンを保存
                    // やっていることはUserDefaults.standard.set(_:forKey:)と同じ
                    UserDefaults.standard.qiitaAccessToken = accessToken.token
                    // 画面遷移
                        self.output.showSearch()
                case .failure(let error):
                    self.output.get(error: error)
            }
        }
    }

    
    func login() {
        output.openOAuthURL()
    }

    func nonLogin() {
        output.showSearch()
    }


}
