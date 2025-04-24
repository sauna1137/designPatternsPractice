//
//  SingleResponsibilityP.swift
//  designPatterns
//
//  Created by KS on 2025/04/15.
//
//  Single Responsibility Principle
//  単一責任原則
//  この原則は、クラスは単一の責任を持つべきであり、その責任を完全にカプセル化するべきであることを示しています。
//  つまり、クラスは一つのことだけを行い、そのことに集中するべきです。これにより、コードの可読性と保守性が向上します。

//  例えば、日記アプリケーションを考えてみましょう。
//  日記のエントリを管理するクラスと、ファイルの保存や読み込みを行うクラスを分けることで、単一責任原則を遵守することができます。
//  これにより、日記のエントリを管理するクラスは、エントリの追加や削除などの責任を持ち、
//  ファイルの保存や読み込みを行うクラスは、ファイルの保存や読み込みなどの責任を持つことができます。
//  これにより、コードの可読性と保守性が向上します。


import Foundation

class Journal : CustomStringConvertible {
    var entries: [String] = []
    var count = 0

  func addEntry(_ entry: String) -> Int {
    count += 1
    entries.append(entry)
    return count - 1
  }

  func removeEntry(at index: Int) {
    entries.remove(at: index)
  }

  var description: String {
    return entries.joined(separator: "\n")
  }

  // アンチパターン
  // ここで、Journalクラスは、日記のエントリを管理する責任を持っています。
  // しかし、ファイルの保存や読み込みの責任を持つべきではありません。
  // そのため、FileManagerクラスを作成して、ファイルの保存と読み込みの責任を持たせます。
  func save(_ filename: String) {
    // save file
  }

  func load(_ filename: String) {
    // load file
  }

  func load(_ filename: String, _ journal: Journal) {
    // load file
  }
}

// ここで、FileManagerクラスは、ファイルの保存と読み込みの責任を持っています。
class Persistence {
  func saveToFile(_ filename: String, _ journal: Journal) {
    // save file
  }

  func loadFromFile(_ filename: String, _ journal: Journal) {
    // load file
  }
}
