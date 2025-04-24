//
//  InterfaceSegregationP.swift
//  designPatterns
//
//  Created by KS on 2025/04/19.
//

//  Interface Segregation Principle
//  インターフェース分離の原則
//  この原則は、クライアントは自分が使用しないメソッドに依存してはいけないことを示しています。
//  つまり、インターフェースは特定のクライアントに対して必要なメソッドだけを提供するべきです。
//  大きなインターフェースを小さなインターフェースに分割することで、
//  クライアントは自分が必要とするメソッドだけを実装すればよくなります。

class Document {
}

protocol Machine {
  func print(document: Document)
  func scan(document: Document)
  func fax(document: Document)
}

enum NoRequiredFunctionality: Error {
  case doesNotFax
}

class MultiFunctionPrinter: Machine {
  func scan(document: Document) {
    // OK
  }
  
  func fax(document: Document) {
    // OK
  }
  
  func print(document: Document) {
    // OK
  }
}

// アンチパターン
// これは、インターフェース分離の原則に従っていない例です。
class oldFashionedPrinter: Machine {

  func print(document: Document) {
    // OK
  }

  func scan(document: Document) {
    // NG
  }

  func fax(document: Document) {
//    throw NoRequiredFunctionality.doesNotFax
  }
}

// ↓

// これは、インターフェース分離の原則に従った例です。
protocol Printer {
  func print(document: Document)
}

protocol Scanner {
  func scan(document: Document)
}

protocol Fax {
  func fax(document: Document)
}


class OldFashionedPrinter: Printer {
  func print(document: Document) {
    // OK
  }
}

class PhotoCopier: Scanner, Printer {
  func scan(document: Document) {
    // OK
  }
  func print(document: Document) {
    // OK
  }
}

class MultiFunctionDevice: Scanner, Printer, Fax {
  func scan(document: Document) {
    // OK
  }

  func print(document: Document) {
    // OK
  }

  func fax(document: Document) {
    // OK
  }
}

protocol MultiFunction: Scanner, Printer, Fax {}

class NewPrinter: MultiFunction {
  func scan(document: Document) {
    // OK
  }

  func print(document: Document) {
    // OK
  }

  func fax(document: Document) {
    // OK
  }
}

// decorator パターン
// decoratorパターンとは、既存のクラスに新しい機能を追加するためのデザインパターンです。
class NewPrinter2: Scanner, Printer {

  let printer: Printer
  let scanner: Scanner

  init(printer: Printer, scanner: Scanner) {
    self.printer = printer
    self.scanner = scanner
  }

  func print(document: Document) {
    printer.print(document: document)
  }

  func scan(document: Document) {
    scanner.scan(document: document)
  }
}


