# 概要

このリポジトリーはポートフォリオで製作したアプリのリポジトリです。
尚、このアプリの主目的は**MVPアーキテクチャで作成することです。**
アプリの機能は別のポートフォリオで作成したアプリ「SearchQiita」と同じです。
SearchQiitaのリポジトリ→　https://github.com/HaruhikoMotokawa/SearchQiita.git

SearchQiitaの基本機能は以下の通りです。

- SwiftPackageManagerを使ってライブラリを導入
  - Lotti
  - Alamofire
  - Kingfisher
- OAuth2.0による認証/認可の機能実装
- QiitaAPIを使って記事を取得する
  - 取得した認証トークンを使ってユーザーが投稿した記事を取得する
  - 入力した文字を記事タイトルの検索ワードとして使用して記事を取得する
- 取得した記事をWebKitを使って表示する
   
