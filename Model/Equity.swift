//
//  Equity.swift
//  Bond_Helper
//


import Foundation
import RealmSwift

enum bondType: String {
    case cash = "现金"
    case stock = "股票"
    case fund = "基金"
    case bond = "债券"
}

class Equity: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var user_id: Int = 0
    @objc dynamic var type: String = bondType.cash.rawValue
    @objc dynamic var amount: Float = 0
    @objc dynamic var ratio: Float = 0
}
