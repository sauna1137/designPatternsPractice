//
//  LiskovSubstitutionP.swift
//  designPatterns
//
//  Created by KS on 2025/04/16.
//

// Liskov Substitution Principle
// リスコフの置換原則
// この原則は、サブタイプはそのスーパークラスのインスタンスとして扱えるべきであることを示しています。
// つまり、スーパークラスのインスタンスを期待する場所にサブクラスのインスタンスを置いても、プログラムの正しさが保たれるべきです。
// これにより、コードの再利用性が向上し、既存のコードを変更せずに新しい機能を追加できるようになります。

class Rectangle: CustomStringConvertible {

  private var _width: Double = 0
  private var _height: Double = 0

  var width: Int {
    get { return Int(_width) }
    set { _width = Double(newValue) }
  }

  var height: Int {
    get { return Int(_height) }
    set { _height = Double(newValue) }
  }

  var area: Int {
    return width * height
  }

  public var description: String {
    return "Rectangle(width: \(width), height: \(height), area: \(area))"
  }
}

class Square: Rectangle {
  override var width: Int {
    get { return self.width }
    set {
      self.width = newValue
      height = newValue
    }
  }

  override var height: Int {
    get { return self.height }
    set {
      self.height = newValue
      width = newValue
    }
  }
}


func setAndMeasure(_ rect: Rectangle) {
  rect.width = 5
  rect.height = 10
  print("Area: \(rect.area)")
}

private func mainLS() {
  let rc = Rectangle()
  setAndMeasure(rc)

  // アンチパターン measureの値が100になる
  let sq = Square()
  setAndMeasure(sq)
}


// memo
/*
 リスコフの置換原則(LSP: Liskov Substitution Principle)は、「サブクラスのオブジェクトが、親クラスのオブジェクトの代わりに使用されても、プログラムの正しさが損なわれてはならない」という原則です。簡単に言うと：親クラスで期待される動作を、子クラスが変更してはいけない。子クラスは親クラスの「約束」をすべて守りつつ、機能を拡張する必要がある

 LSPを守るには：
 事前条件を強化してはいけない（親クラスが受け付ける入力をすべて受け付ける）
 事後条件を弱めてはいけない（親クラスが保証することはすべて保証する）
 親クラスの不変条件を保持する
 例外を新たに発生させない

 */
