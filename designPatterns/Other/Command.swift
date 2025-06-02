//
//  Command.swift
//  designPatterns
//
//  Created by KS on 2025/05/30.
//
// commandパターンは、オブジェクトの操作をオブジェクトとしてカプセル化するデザインパターンです。
// これにより、操作の履歴を記録したり、操作を取り消したりすることが容易になります。
// ユーザーの操作を記録して後で再実行する場合や、操作をキューに入れて順番に実行する場合などに使用します。

import Foundation

class BankAccount: CustomStringConvertible {

  private var balance = 0
  private let overdraftLimit = -500

  func deposit(_ amount: Int) {
    balance += amount
    print("Deposited \(amount), new balance is \(balance)")
  }

  func withdraw(_ amount: Int) -> Bool {
    if (balance - amount >= overdraftLimit) {
      balance -= amount
      print("Withdrew \(amount), new balance is \(balance)")
      return true
    }
    return false
  }
}

protocol Command {
  func call()
}

class BankCommand: Command {

  init(account: BankAccount, action: Action, amount: Int) {
    self.account = account
    self.action = action
    self.amount = amount
  }

  private var account: BankAccount

  enum Action {
    case deposit
    case withdraw
  }

  private var action: Action
  private var amount: Int = 0
  private var success: Bool = false

  func call() {
    switch action {
    case .deposit:
      account.deposit(amount)
      success = true
    case .withdraw:
      success = account.withdraw(amount)
    }
  }

  func mainCommand() {
    let ba = BankAccount()

    let commands = [
      BankCommand(account: ba, action: .withdraw, amount: 50),
      BankCommand(account: ba, action: .withdraw, amount: 200)
    ]
  }
}
