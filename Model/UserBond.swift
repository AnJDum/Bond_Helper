//
//  UserBond.swift
//  Bond_Helper
//


import Foundation
import RealmSwift
class UserBond: Object {
    @objc dynamic var _id = ObjectId.generate()
    @objc dynamic var user_id:Int = 0
    @objc dynamic var bondName:String = ""
    @objc dynamic var amount:Double = 0.0
    
}
