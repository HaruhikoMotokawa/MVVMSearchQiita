//
//  SearchPresenter.swift
//  MVPSearchQiita
//
//  Created by 本川晴彦 on 2023/08/02.
//

import Foundation

/// 外から受け取るアクションのプロトコル
protocol SearchPresenterInput {
    /// テーブルビューのセルの表示数
    var numberOfItems: Int { get }
    /// myArticleButtonがタップされたらログイン中のユーザーが投稿した記事を取得する
    /// 最終的にテーブルビューをVC側で読みこませる
    /// エラーが出た際の処理をVC側に渡す
    func myArticleButtonTapped()
    /// searchButtonがタップされたら引数inputTextの値をQiitaAPIに渡して検索する
    /// 成功した場合はテーブルビューをVC側で読み込ませる
    /// 失敗した場合はVC側でログを出す
    func searchButtonTapped(inputText: String?)
    /// タップされたセル番号をプレゼンターに教える
    func didSelect(index: Int)
    /// セルの番号をプレゼンターに伝えて、必要な情報を返してもらう
    func item(index: Int) -> QiitaItemModel
}

/// 外へ出すアクションのプロトコル
protocol SearchPresenterOutput: AnyObject {
    /// キーボードを閉じるように指示
    func viewEndEditing()
    /// テーブルビューを再読み込み指示
    func reloadTableView()
    /// エラーが出たので処理するように指示
    func getError(error:Error)
    /// 引数のパラメーターを持って画面遷移するように指示
    func showWeb(qiitaItemModel: QiitaItemModel)
}

/// プレゼンターを管理
final class SearchPresenter {
    /// 外に出すprotocolに準拠したインスタンス（ViewControllerのこと）
    private weak var output:SearchPresenterOutput!
    /// APIをインスタンス化
    private var qiitaAPI: QiitaAPIProtocol!
    /// この中で変化するパラメーター
    private var qiitaItems: [QiitaItemModel]
    /// イニシャライザー
    init(output: SearchPresenterOutput!, qiitaAPI: QiitaAPIProtocol = QiitaAPI.shared) {
        self.output = output
        self.qiitaAPI = qiitaAPI
        self.qiitaItems = []
    }
}

/// ViewControllerから指示を受けた際の処理
extension SearchPresenter: SearchPresenterInput {
    // 表示する検索記事のデータを渡す
    func item(index: Int) -> QiitaItemModel {
        qiitaItems[index]
    }
    // 取得したデータモデルの数
    var numberOfItems: Int {
        qiitaItems.count
    }
    // タップされたことを受けて、Web画面を開くように指示を出す
    func didSelect(index: Int) {
        self.output.showWeb(qiitaItemModel: qiitaItems[index])
    }
    // ユーザーが今までに投稿した記事を検索してデータを渡す
    func myArticleButtonTapped() {
        QiitaAPI.shared.getMyArticle { [weak self]result in
            guard let sSelf = self else { return }
            switch result {
                case .success(let items):
                    sSelf.qiitaItems = items
                    // ここでアウトプットprotocol
                    sSelf.output.reloadTableView()
                case .failure(let error):
                    // ここでアウトプットprotocol
                    sSelf.output.getError(error: error)
            }
        }
    }
    // 検索ワードを使って記事タイトルを検索してデータを渡す
    func searchButtonTapped(inputText: String?) {
        print("ボタンタップしたで")
        guard let inputText  else { return }
        guard !inputText.isEmpty else { return }

        QiitaAPI.shared.getItems(inputText: inputText) { [weak self] result in
            guard let self else { return }
            // キーボードを閉じさせる指示
            output.viewEndEditing()
            switch result {
                case .success(let item):
                    print("検索成功したで")
                    qiitaItems = item
                    print("qiitaItems.count:\(qiitaItems.count)")
                    // テーブルビューを読み込ませる指示
                    output.reloadTableView()
                case .failure(let error):
                    // エラーが出た時の処理
                    output.getError(error: error)
            }
        }
    }
}
