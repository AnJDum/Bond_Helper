//
//  Start.swift
//  Bond_Helper
//


import UIKit
import RealmSwift

class StartController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 调用API
        //        let   url =  URL (string:  "https://raw.githubusercontent.com/sqc-cser/great/master/jsonfile2.js" )!
        //        guard let data = try?  Data (contentsOf: url)else {
        //            fatalError("can't find url")
        //        }
        //        guard let list = try? JSONDecoder().decode(BondList.self, from: data) else{
        //            fatalError("can't decode")
        //        }
        //        print(list.Bond)
        
        //
        //
        //本地调试数据库
        let bondlist = loadBondData("jsonfile.js")
        print(bondlist.Bond[0])
        let safeBondList = loadBondData("jsonfile_safe.js")
        print(safeBondList.Bond[0])
        
//        storeBondData(list: bondlist)
//        storeSafeBondData(list: safeBondList,oriCount:bondlist.Bond.count)
//        delBondData()
        //第一次存久期的时候取消这行代码的注释
//       storeDurConv()
    }
    
    //本地调试数据库
    func loadBondData(_ fileName:String) -> BondList {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            fatalError("can't find file")
        }
        print(url)
        guard let data = try? Data(contentsOf: url) else{
            fatalError("can't load url")
        }
        guard let list = try? JSONDecoder().decode(BondList.self, from: data) else{
            fatalError("can't decode")
        }
        return list
    }
    
    func storeBondData(list:BondList){
        let realm = try! Realm ()
        for value in list.Bond{
            var newbond = RealmBond()
            newbond.assureMean = value.assureMean
            newbond.code = value.code
            newbond.descri = value.description
            newbond.dueDate = value.dueDate
            newbond.duration = value.duration
            newbond.frequency = value.frequency
            newbond.guarantor = value.guarantor
            newbond.index = value.index
            newbond.industry = value.industry
            newbond.interestRate = value.interestRate
            newbond.launchDate = value.launchDate
            newbond.name = value.name
            newbond.originator = value.originator
            newbond.paymentNote = value.paymentNote
            newbond.pledgeCode = value.pledgeCode
            newbond.price = value.price
            newbond.quantity = value.quantity
            newbond.releaseDate = value.releaseDate
            newbond.MacDur = 0.0
            newbond.MacConv = 0.0
            try! realm.write {
                realm.add(newbond)
            }
        }
    }
    
    func storeDurConv(){
        let realm = try! Realm ()
        var bonds: Results<RealmBond>?
        bonds = realm.objects(RealmBond.self)
        for l in 0...bonds!.count-1
        {
            if bonds![l].code.count == 6
            {
                
                culBondData(_l: l)
                
            }
        }
    }
    
    func culBondData(_l: Int){
        // 现金流都在cashFuture[]和cashPresent[]里面哦
        
        let realm = try! Realm ()
        var bonds: Results<RealmBond>?
        bonds = realm.objects(RealmBond.self)
        let rfRates: Float = 0.0306 //市场利率
        var i: Int = 0 //每年付息次数
        let bondDur: Int = Int(bonds![_l].duration) //多少年
        var duration: Float = 0.0 //久期
        var convexity: Float = 0.0 //凸度
        
        if bonds![_l].paymentNote == "按半年付息"{
            i = 2
        }
        else if bonds![_l].paymentNote == "按年付息"{
            i = 1
        }
        
        
        if i != 0{
            
            //"按半年付息"& "按年付息"的情况
            var cashFuture = [Float](repeating: 0, count: Int(bondDur * i) + 1) //未来的支付
            var cashPresent = [Float](repeating: 0, count: Int(bondDur * i) + 1) //未来支付的现值
            
            cashFuture[0] = 0 - bonds![_l].price
            cashPresent[0] = 0 - bonds![_l].price
            for k in 1...Int(bondDur * i) - 1{
                cashFuture[k] = bonds![_l].price * bonds![_l].interestRate / Float(i)/100
                cashPresent[k] = cashFuture[k] / pow((1 + rfRates / Float(i)), Float(k) )
//                print(k,":  ",cashFuture[k])
//                print(k,":  ",cashFuture[k])
            }
            cashFuture[Int(bondDur * i)] = bonds![_l].price * (1 + bonds![_l].interestRate / Float(i)/100)
            var temp: Float = pow((1 + rfRates / Float(i)), Float((bondDur * i)))
            cashPresent[Int(bondDur * i)] = cashFuture[bondDur * i] / temp
            
//            print("8:  ",cashFuture[8])
//            print("8:  ",cashPresent[8])
            //计算久期凸度
            var a: Float = 0.0
            var b: Float = 0.0
            var c: Float = 0.0
            
            for k in 1...Int(bondDur * i){
                a += cashPresent[k] * Float(k) / Float(i)
                b += cashPresent[k]
                c += cashPresent[k] * (Float(k) / Float(i)) * (Float(k) / Float(i))
            }
//            print("a:  ",a)
//            print("c:  ",c)
//            print("b:  ",b)
            duration = a / b
            convexity = c / b
        }
        else{
            //"到期一次付息"& "其他"的情况
            //久期凸度
            duration = bonds![_l].duration
            convexity = bonds![_l].duration * bonds![_l].duration
            //现金流
            var cashFuture = [Float](repeating: 0, count: 2)
            var cashPresent = [Float](repeating: 0, count: 2)
            cashFuture[0] = -bonds![_l].price
            cashPresent[0] = -bonds![_l].price
            cashFuture[1] = bonds![_l].price * (1 + bonds![_l].interestRate * bonds![_l].duration / 100)
            cashPresent[1] = cashFuture[1] / pow((1.0 + rfRates), Float(bondDur))
        }
        
        //储存
        try! realm.write {
            bonds![_l].MacDur = duration;
            bonds![_l].MacConv = convexity;
        }
    }
    
    func delBondData(){
        let realm = try! Realm ()
        try! realm.write {
            let results = realm.objects(RealmBond.self)
            realm.delete(results)
        }
    }
    func storeSafeBondData(list:BondList,oriCount:Int){
        let realm = try! Realm ()
        for value in list.Bond{
            var newbond = RealmBond()
            newbond.assureMean = value.assureMean
            newbond.code = value.code
            newbond.descri = value.description
            newbond.dueDate = value.dueDate
            newbond.duration = value.duration
            newbond.frequency = value.frequency
            newbond.guarantor = value.guarantor
            newbond.index = value.index + oriCount
            newbond.industry = value.industry
            newbond.interestRate = value.interestRate
            newbond.launchDate = value.launchDate
            newbond.name = value.name
            newbond.originator = value.originator
            newbond.paymentNote = value.paymentNote
            newbond.pledgeCode = value.pledgeCode
            newbond.price = value.price
            newbond.quantity = value.quantity
            newbond.releaseDate = value.releaseDate
            newbond.MacDur = 0.0
            newbond.MacConv = 0.0
            try! realm.write {
                realm.add(newbond)
            }
        }
    }
}
