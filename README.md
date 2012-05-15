はじめに
================
本アプリはクオリサイトテクノロジーズの社内勉強会用に作成したTwitterクライアントです(iPhone用)。さほど凝った機能は持ちませんが、iOSアプリ開発のイロハは理解出来るようにしたつもりです。今後も少しずつバージョンアップしていく予定です。   
勉強会を完走すればこの程度のアプリは自作出来るようにしたいと思っています。覚えることはそれなりにありますが、頑張ってみて下さい。

講座に必要な基礎知識
----------------
Mac関係の前提知識は不要です。ただ、（ソフトウェア会社の勉強会なので）プログラミングの経験はあるものとしています。

開発環境
----------------
開発環境は準備済みです。以下がインストールされているMacを使っています。
  * Mac OSX 10.7.3
  * Xcode 4.3.2

ちなみにMacはi5のSSDです。豪華ですねぇ。  

iPhoneアプリ開発はしっかりやろうと思うと覚えることが相当沢山あるので、本記事では作成するアプリに必要となるものに絞って解説をしていきます。いくつか外部ライブラリも使っていますが、ここで挙げる以外の選択肢も多くあると思います。ご自分で開発する際にはここで得た知識を元に、改めて検討してみることをお勧めします。  

講座紹介
----------------
各講義の題名と講義内容のダイジェストです。

### 第一回：本講座の目的
初回と言う事でXcodeの使い方から解説します。本講座はOfflineViewを作れるようになることを目標に、必要な知識をピンポイントで解説していくスタンスを取るつもりです。ですので、Xcodeについても網羅的な説明は避けて、アプリ作成に必要となるところに絞って解説を行います。  
Xcodeには色々と便利な機能もありますが、それは追々説明出来ればと思っています。

* iOSアプリの紹介  
  Xcodeで実行出来るアプリをいくつか集めてきたのでご紹介します  
  [Molecules](http://www.sunsetlakesoftware.com/molecules) [FuelView](http://cocoawithlove.com/2011/06/process-of-writing-ios-application.html)
* Twitterクライアントの紹介  
  本講座の目標である、OfflineViewについて解説します。講座を完走すればOfflineViewと同程度のアプリは作れるようになる* * はずです
* OfflineViewの主な機能
  * ログインユーザのタイムライン表示
  * Web閲覧機能
  * サムネイル表示＆Webの先読み
* Xcodeを使ってサンプルアプリを作成（ハンズオン）  
  実際に手を動かしてアプリを作成してみましょう。
  * テンプレートから新規にプロジェクトを作成
  * Storyboardからボタン* ラベルを追加
  * Segueを使った画面遷移



### 第2回：HelloWorldアプリケーションの作成
* Xcodeを使ってサンプルアプリを作成（続き）（ハンズオン）
  * 画面遷移アニメーション
  * コントローラのプロパティ設定（背景色等）
* HelloWorldプロジェクトの作成（ハンズオン）
  * 完成版を見せる
  * IBOutlet／IBAction
  * 実装

### 第３回：Twitterクライアントの作成１（紙芝居の設計）
※紙芝居を作成後、叙々に機能追加をしていく
* 画面設計
　→資料が必要
* クラス設計

### 第四回：Twitterクライアントの作成２（紙芝居の実装１）（ハンズオン）
* クラス作成
* 画面表示

### 第５回：Twitterクライアントの作成２（紙芝居の実装２）（ハンズオン）
* クラス作成
* 画面表示

### 第６回：iOS機能紹介（CoreData）
* 紹介
* FetchResultControllerの追加
* サンプル実装（ハンズオン）

### 第7回：外部ライブラリの機能紹介（RestKit）
* 紹介
* サンプル実装（ハンズオン）

### 第８回：TwitterAPI
* Twitter Developerへの登録
* TimeLineAPIの紹介
* iOSからタイムラインを取得
  * GTMの紹介
  * GTMを使ってタイムラインを取得（ハンズオン）

### 第９回：Delegateについて

### 第１０回：TwitterAPIの組み込み
* CoreDataの組み込み（あまりやることはない？）

### 第11回：Webページの先読み

### 第12回：広告表示（iAd）
