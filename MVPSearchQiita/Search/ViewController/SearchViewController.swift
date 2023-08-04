//
//  SearchViewController.swift
//  MVPSearchQiita
//
//  Created by 本川晴彦 on 2023/07/26.
//

import UIKit
/// 検索画面
final class SearchViewController: UIViewController {
    /// ユーザー自身が投稿した記事を取得するボタン
    @IBOutlet private weak var myArticleButton: UIButton! {
        didSet {
            myArticleButton.addTarget(self, action: #selector(myArticleButtonTapped), for: .touchUpInside)
        }
    }
    /// 検索する文字の入力欄
    @IBOutlet private weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    /// 検索を実行するボタン
    @IBOutlet private weak var searchButton: UIButton! {
        didSet {
            searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        }
    }
    /// 検索結果を表示するテーブルビュー
    @IBOutlet private weak var resultTableView: UITableView! {
        didSet {
            let cellNib = UINib(nibName: CustomCell.className, bundle: nil)
            resultTableView.register(cellNib, forCellReuseIdentifier: CustomCell.className)
            resultTableView.dataSource = self
            resultTableView.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 接続用のプロパティとメソッド
    private var presenter: SearchPresenterInput!
    func inject(presenter: SearchPresenterInput) {
        self.presenter = presenter
    }

    ///  ユーザー自身が作成した記事を表示するメソッド
    @objc internal func myArticleButtonTapped() {
        self.presenter.myArticleButtonTapped()
    }

    /// ワード検索で記事を表示するメソッド
    @objc private func searchButtonTapped() {
        let inputText = searchTextField.text
        self.presenter.searchButtonTapped(inputText: inputText)
    }
}
/// プレゼンターからVCに対しての指示内容
extension SearchViewController: SearchPresenterOutput {
    /// キーボード閉じる
    func viewEndEditing() {
        view.endEditing(true)
    }

    /// テーブルビューの読み込み
    func reloadTableView() {
        self.resultTableView.reloadData()
    }

    /// エラーが出た処理
    func getError(error: Error) {
        print(error.localizedDescription)
    }

    /// 画面遷移する指示
    func showWeb(qiitaItemModel: QiitaItemModel) {
        Router.shared.showWeb(from: self, qiitaItemModel: qiitaItemModel)
    }
}

extension SearchViewController: UITableViewDelegate {
    /// セルをタップしたら記事のデータを持ってWeb画面に遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タップされたことを知らせる
        self.presenter.didSelect(index: indexPath.row)
    }
}

extension SearchViewController: UITableViewDataSource {
    /// テーブルビューのセルの表示数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfItems
    }

    /// セルに表示するデータを渡す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = resultTableView.dequeueReusableCell(withIdentifier: CustomCell.className, for: indexPath) as? CustomCell  else {
            return UITableViewCell()
        }
        // セルに表示するデータをプレゼンターからもらう
        let qiitaItemModel = presenter.item(index: indexPath.row)
        cell.configure(qiitaItemModel: qiitaItemModel)
        return cell
    }
}

extension SearchViewController: UITextFieldDelegate {
    /// 文字入力後にリターンボタンでキーボード閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
