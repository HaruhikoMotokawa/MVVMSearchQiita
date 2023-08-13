//
//  WebViewController.swift
//  MVPSearchQiita
//
//  Created by 本川晴彦 on 2023/07/31.
//

import UIKit
import WebKit
/// ウェブビュー
final class WebViewController: UIViewController {
    /// 指定されたURLを表示する
    @IBOutlet private weak var webView: WKWebView!

    //　疎結合
    private var presenter: WebPresenterInput!
    func inject(presenter: WebPresenterInput) {
        self.presenter = presenter
    }
    
    // 処理が多くないのでそのまま直接定義
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoaded()
    }
}

extension WebViewController: WebPresenterOutput {
    func webViewLoad(request: URLRequest) {
        self.webView.load(request)
    }

}
