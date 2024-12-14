//
//  MyInformationController.swift
//  Bond_Helper
//


import UIKit
import RealmSwift

class MyInformationController: UIViewController,  EquityDelegate, ViewControllerDelegate, BondRecommendDelegate{
    
    func UpdateUI() {
        viewDidLoad()
    }
    
    func jumpToHomePage(){
         self.performSegue(withIdentifier: "toHomePage", sender: self)
    }
    
    func jumpToRecommend(){
         self.performSegue(withIdentifier: "toRecommend", sender: self)
    }
    
    
    var currentUser = ""
    var userId = 0
    //数据库操作
    var equity: Results<Equity>?
    var users: Results<User>?
    let realm = try! Realm()
    
    @IBOutlet weak var currentUserLabel: UILabel!
    @IBOutlet weak var totalEquity: UILabel!
    @IBOutlet weak var cash: UILabel!
    @IBOutlet weak var stock: UILabel!
    @IBOutlet weak var bond: UILabel!
    @IBOutlet weak var fund: UILabel!
    @IBOutlet weak var riskGrade: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUserLabel.text = currentUser
       
        //从数据库中查找
        users = realm.objects(User.self).filter("name == %@", currentUserLabel.text)
        riskGrade.text = users![0].riskGrade
        userId = users![0].id
        
        equity = realm.objects(Equity.self).filter("user_id == %@ AND type == 'cash'", userId)
        cash.text = String(equity![0].amount)
        var tmp = equity![0].amount
        
        equity = realm.objects(Equity.self).filter("user_id == %@ AND type == 'stock'", userId)
        stock.text = String(equity![0].amount)
        tmp = tmp + equity![0].amount
        
        equity = realm.objects(Equity.self).filter("user_id == %@ AND type == 'bond'", userId)
        bond.text = String(equity![0].amount)
        tmp = tmp + equity![0].amount
        
        equity = realm.objects(Equity.self).filter("user_id == %@ AND type == 'fund'", userId)
        fund.text = String(equity![0].amount)
        tmp = tmp + equity![0].amount
        
        totalEquity.text = String(tmp)
        
    }
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //实现登录界面和用户信息界面的正向传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editEquity"{
            let vc = segue.destination as! EquityController
            vc.cash = cash.text!
            vc.stock = stock.text!
            vc.bond = bond .text!
            vc.fund = fund.text!
            vc.userId =  userId
            vc.flag = true
            vc.delegate = self
        }
        else if segue.identifier == "toRecommend"{
            let vc = segue.destination as! BondRecommendViewController
            vc.delegate = self
            vc.userId =  userId
        }
        else if segue.identifier == "toHomePage"{
            let vc = segue.destination as! ViewController
            vc.delegate = self
        }
        else if segue.identifier == "toPieChart"{
            let vc = segue.destination as! ChartController
             vc.userId =  userId
            
        }
        else if segue.identifier == "showUserBonds"{
            let vc = segue.destination as! ShowSelfBond
            vc.user_id = userId
        }
    }
   
}
