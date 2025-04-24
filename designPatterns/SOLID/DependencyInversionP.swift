//
//  DependencyInversionP.swift
//  designPatterns
//
//  Created by KS on 2025/04/20.
//

//  Dependency Inversion Principle
//  依存関係逆転の原則
//  この原則は、高レベルのモジュールは低レベルのモジュールに依存してはいけないことを示しています。
//  どちらも抽象に依存するべきです。つまり、具体的な実装に依存するのではなく、
//  抽象化されたインターフェースやクラスに依存することで、コードの柔軟性と再利用性が向上します。

import Foundation

enum Relationship {
  case parent
  case child
  case sibling
}

class Person {
  var name = ""
  init(name: String = "") {
    self.name = name
  }
}

// Low-level module
class Relationships: RelationshipBrowser {
  var relations: [(Person, Relationship, Person)] = []

  func addParentAndChild(_ parent: Person, _ child: Person) {
    relations.append((parent, .parent, child))
    relations.append((child, .child, parent))
  }

  func findAllChildren(of name: String) -> [Person] {
    return relations.filter { $0.name == name && $1 == .parent && $2 === $2 }
      .map({$2})
  }
}

// High-level module
class Research {

  // アンチパターン
  // ResearchクラスがRelationshipsクラスに依存しています。
  init(_ relationships: Relationships) {
    let relations = relationships.relations
    for r in relations where r.0.name == "John" && r.1 == .parent {
      print("John has a child called \(r.2.name)")
    }
  }

  init(_ browser: RelationshipBrowser) {
    for p in browser.findAllChildren(of: "John") {
      print("John has a child called \(p.name)")
    }
  }
}

func main() {
  let parent = Person(name: "John")
  let child = Person(name: "Jane")
  let child2 = Person(name: "Jack")

  let relationships = Relationships()
  relationships.addParentAndChild(parent, child)
  relationships.addParentAndChild(parent, child2)

  let _ = Research(relationships)
}


// 改善↓

protocol RelationshipBrowser {
  func findAllChildren(of name: String) -> [Person]
}

