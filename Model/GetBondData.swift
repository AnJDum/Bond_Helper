//
//  GetBondData.swift
//  Bond_Helper
//


import Foundation
import RealmSwift
//json数据中暂时传的都是字符串
struct BondList:Codable {
    var Bond:[Bond]
}

struct Bond:Codable {
    var index :Int
    //var code = 10000
    var code :String
    var name :String
    var originator :String
    //var quantity = 1.1
    var quantity :Float
    //var duration = 1
    var duration:Float
    //var price = 100
    var price :Float
    //var interstRate = 0.0
    var interestRate :Float
    var description :String
    //var frequency = 1
    var frequency :Float
    var releaseDate :String
    var launchDate :String
    var paymentNote :String
    var dueDate :String
    var guarantor :String
    var assureMean :String
    var industry :String
    var pledgeCode :String
//    var MacDur: Float
//    var MacConv: Float
}

class RealmBond: Object {
    @objc dynamic var index :Int=10000
    //var code = 10000
    @objc dynamic var code :String=""
    @objc dynamic var name :String=""
    @objc dynamic var originator :String=""
    //var quantity = 1.1
    @objc dynamic var quantity :Float=1.1
    //var duration = 1
    @objc dynamic var duration:Float=1.0
    //var price = 100
    @objc dynamic var price :Float=100.0
    //var interstRate = 0.0
    @objc dynamic var interestRate :Float=0.0
    @objc dynamic var descri :String=""
    //var frequency = 1
    @objc dynamic var frequency :Float=1.0
    @objc dynamic var releaseDate :String=""
    @objc dynamic var launchDate :String=""
    @objc dynamic var paymentNote :String=""
    @objc dynamic var dueDate :String=""
    @objc dynamic var guarantor :String=""
    @objc dynamic var assureMean :String=""
    @objc dynamic var industry :String=""
    @objc dynamic var pledgeCode :String=""
    @objc dynamic var MacDur: Float=0.0
    @objc dynamic var MacConv: Float=0.0

}
