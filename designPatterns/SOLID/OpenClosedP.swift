//
//  OpenClosedP.swift
//  designPatterns
//
//  Created by KS on 2025/04/15.
//
//  Open Closed Principle
//  開放閉鎖原則
//  この原則は、クラスは拡張に対して開放されているべきであり、変更に対して閉鎖されているべきであることを示しています。
//  つまり、既存のコードを変更せずに、新しい機能を追加できるように設計するべきです。
//  開放閉鎖原則を適用することで、コードの保守性、拡張性、再利用性が向上します。新機能の追加が既存コードに影響を与えないため、
//  リグレッションバグのリスクも低減されます

import Foundation
import SwiftUI

struct Product {
  let name: String
  let color: Color
}

class ProductFilter {

  func filterByColor(_ products: [Product], _ color: Color) -> [Product] {
    return products.filter { $0.color == color }
  }

  func filterByName(_ products: [Product], _ name: String) -> [Product] {
    return products.filter { $0.name.contains(name) }
  }

  // アンチパターン
  // Open Closed Principleに従って、フィルタリングの条件を追加する場合は、
  // 新しいメソッドを追加するだけで、既存のコードを変更する必要はありません。
  func filterByColorAndName(_ products: [Product], _ color: Color, _ name: String) -> [Product] {
    return products.filter { $0.color == color && $0.name.contains(name) }
  }
}


// メリット
// 拡張性:新しいフィルタリング条件（例えば価格や在庫状況など）を追加したい場合、新しいSpecificationの実装を作るだけで済みます。
// 既存のコードを変更する必要はありません。
// 結合度の低減: 具体的なフィルタリング条件とフィルタリングのメカニズムが分離されています。
// 再利用性: 異なるSpecificationを組み合わせることで、複雑なフィルタリング条件を作成できます。

protocol Specification {
  associatedtype T
  func isSatisfied(_ item: T) -> Bool
}

// filterプロトコルにSpecificationを追加
// Open Closed Principleに従って、フィルタリングの条件を追加する場合は、
// 新しいFilterを追加するだけで、既存のコードを変更する必要はありません。
protocol Filter {
  associatedtype T
  func filter<spec: Specification>(_ items: [T], _ spec: spec) -> [T]
    where spec.T == T
}

class ColorSpecification: Specification {
  typealias T = Product
  let color: Color
  init(color: Color) {
    self.color = color
  }

  func isSatisfied(_ item: Product) -> Bool {
    return item.color == color
  }
}

class NameSpecification: Specification {
  typealias T = Product
  let name: String
  init(name: String) {
    self.name = name
  }

  func isSatisfied(_ item: Product) -> Bool {
    return item.name.contains(name)
  }
}

class AndSpecification<T, SpecA: Specification, SpecB: Specification>: Specification where SpecA.T == SpecB.T, T == SpecA.T, T == SpecB.T {

  let first: SpecA
  let second: SpecB

  init(_ first: SpecA, _ second: SpecB) {
    self.first = first
    self.second = second
  }

  func isSatisfied(_ item: T) -> Bool {
    return first.isSatisfied(item) && second.isSatisfied(item)
  }
}


class BetterFilter: Filter {
  typealias T = Product

  func filter<spec: Specification>(_ items: [Product], _ spec: spec) -> [Product]
  where spec.T == Product {
    return items.filter { spec.isSatisfied($0) }
  }
}



private func mainO() {

  let products = [
    Product(name: "Red Shirt", color: .red),
    Product(name: "Blue Shirt", color: .blue),
    Product(name: "Green Shirt", color: .green)
  ]

  let productFilter = ProductFilter()
  let redProducts = productFilter.filterByColor(products, .red)

  for product in redProducts {
    print(product.name)
  }

  let betterFilter = BetterFilter()
  let filteredProductsByColor = betterFilter.filter(products, ColorSpecification(color: .red))
  let filteredProductsByName = betterFilter.filter(products, NameSpecification(name: "Shirt"))

  let andSpec = AndSpecification(ColorSpecification(color: .red), NameSpecification(name: "Shirt"))
  let filteredProductsByColorAndName = betterFilter.filter(products, andSpec)

}


// memo
/*

 開放閉鎖原則に基づく方法
 開放閉鎖原則に従う方法では、フィルタリングの「仕組み」と「条件」を分離します：
 フィルタリングの仕組み（FilterプロトコルとBetterFilterクラス）
 一度作ったら変更しない
 どんな条件でも扱える柔軟な設計


 フィルタリング条件（各種Specificationクラス）
 新しい条件は新しいクラスとして追加
 既存のコードに影響を与えない

 これは「多目的な運動場を作っておき、テニスをしたいときはテニス用具を持ち込み、サッカーをしたいときはサッカー用具を持ち込む」ようなものです。運動場自体は変更せず、用途に応じて適切な道具を選ぶだけです。


 6. まとめ
 開放閉鎖原則は、ソフトウェアを拡張しやすく、変更に強くするための重要な設計原則です。
 従来の方法：新機能を追加するたびに既存コードを変更
 開放閉鎖原則に基づく方法：適切な抽象化を行い、新機能は新しいクラスとして追加
 これにより、コードは柔軟になり、将来の変更に対応しやすくなります。Swiftの型システム（associatedtype、typealias、ジェネリクスなど）は、この原則を実装するための強力なツールを提供しています。

 */
