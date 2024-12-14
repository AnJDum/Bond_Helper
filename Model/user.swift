//
//  User.swift
//  Bond_Helper
//


import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var mail: String = ""
    @objc dynamic var birth = Date()
    @objc dynamic var riskGrade = ""
    
}

