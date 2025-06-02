//
//  Strategy.swift
//  designPatterns
//
//  Created by KS on 2025/04/24.
//


// Strategy Pattern
/*
 Strategyパターンでは、同じインターフェイスを実装する交換可能な「アルゴリズム」をいくつか定義して、
 プログラム実行時に適切なアルゴリズムを選択します。ここでいう「アルゴリズム」は「複数あるやり方の中の一つのやり方」という意味です。例えば、
 ファイルをアップロードする機能に例えると、S3 にアップロードするか、Google Cloud Storage
 にアップロードするか、あるいはローカルファイルシステムの /mnt ディレクトリーに入れるか、それぞれの方法が「アルゴリズム」になるわけです。
*/

// Strategyパターンは、クラスの振る舞いを変更するために、
// そのクラスのインスタンスを変更するのではなく、
// インスタンスの振る舞いを変更するために、
// 別のクラスを作成することによって、
// そのクラスの振る舞いを変更することを目的としています。

/*
 Strategyパターンは、以下のような場合に使うことが多いです。
 1. いくつかの関連しているアルゴリズムの「やること」が同じで「やり方」だけ違う時
 例えば、機械学習モデルを RandomForest で作っても DeepLearning で作っても「モデルを作っている」という事実は変わりません。異なるのは、学習/予測のアルゴリズムだけです。

 2. ディスク容量、実行時間、ネットワーク速度のような物理的制限を考慮して実装する時
 ネットワークが遅い時は、画像の画質を多少落として送信すると、ファイルサイズが小さくなるのでもっと早く送信できます。
 Strategyパターンで、動的に「ネットワーク速度」に応じて「画像を送信するアルゴリズム」を入れ替えることができます。

 3. メソッドの振る舞いを if/else で分岐して実装している時
 if/else の分岐条件をそれぞれ「アルゴリズム」として切り離して実装すると、if/else
 が少なくなり、実装したアルゴリズムを他のところで再利用できます。
 */

enum OutputFormat {
  case markdown
  case html
}

protocol ListStrategy {
  init()
  func start(_ buffer: inout String)
  func end(_ buffer: inout String)
  func addListItem(buffer: inout String, _ item: String)
}

class MarkdownListStrategy: ListStrategy {
  required init() {}

  func start(_ buffer: inout String) {
  }
  func end(_ buffer: inout String) {
  }

  func addListItem(buffer: inout String, _ item: String) {
    buffer.append("")
  }
}

class HtmlListStrategy: ListStrategy {
  required init() {}

  func start(_ buffer: inout String) {
    buffer.append("<ul>")
  }
  func end(_ buffer: inout String) {
    buffer.append("</ul>")
  }
  func addListItem(buffer: inout String, _ item: String) {
    buffer.append("<li>\(item)</li>")
  }
}

import Foundation

class TextProcessor: CustomStringConvertible {

  private var buffer = ""
  private var listStrategy: ListStrategy

  init(_ outputFormat: OutputFormat) {
    switch outputFormat {
    case .markdown:
      listStrategy = MarkdownListStrategy()
    case .html:
      listStrategy = HtmlListStrategy()
    }
  }

  func setOutputFormat(_ outputFormat: OutputFormat) {
    switch outputFormat {
    case .markdown:
      listStrategy = MarkdownListStrategy()
    case .html:
      listStrategy = HtmlListStrategy()
    }
  }

  func appendList(_ items: [String]) {
    listStrategy.start(&buffer)
    for item in items {
      listStrategy.addListItem(buffer: &buffer, item)
    }
    listStrategy.end(&buffer)
  }

  func clear() {
    buffer = ""
  }

  var description: String {
    return buffer
  }

}

func mainForStrategy() {
  let tp = TextProcessor(.markdown)
  tp.appendList(["foo", "bar", "baz"])
  print(tp.description)
}

