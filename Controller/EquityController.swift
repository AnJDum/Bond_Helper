//
//  EquityController.swift
//  Bond_Helper
//

import UIKit
import RealmSwift
var cashRatio :Float = 0.0
var stockRatio :Float = 0.0
var fundRatio :Float = 0.0
var bondRatio :Float = 0.0
var cashString :String = ""
var cashFloat :Float = 0.0
var stockString :String = ""
var stockFloat :Float = 0.0
var fundString :String = ""
var fundFloat :Float = 0.0
var bondString :String = ""
var bondFloat :Float = 0.0

protocol EquityDelegate {
    func UpdateUI()
}

class EquityController: UIViewController {
    
    var userId = 0
    var cash = ""
    var stock = ""
    var bond = ""
    var fund = ""
    var flag = false
    
    var delegate:EquityDelegate?
    
    @IBOutlet weak var cashAmount: UITextField!
    @IBOutlet weak var stockAmount: UITextField!
    @IBOutlet weak var fundAmount: UITextField!
    @IBOutlet weak var bondAmount: UITextField!
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cashAmount.resignFirstResponder()
        stockAmount.resignFirstResponder()
        fundAmount.resignFirstResponder()
        bondAmount.resignFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if(flag)//修改资产
        {
            cashAmount.text = cash
            stockAmount.text = stock
            bondAmount.text = bond
            fundAmount.text = fund
        }
    }
    
    //数据库操作
    var equity: Results<Equity>?
    let realm = try! Realm()
    
    
    @IBAction func confirmButtom(_ sender: Any) {
        
        print("点击")
        if(flag)//修改资产
        {
            //检查各个信息栏是否为空,以及数据类型是否符合要求
            if Float(cashAmount.text!) == nil{
                showMsgbox(_message: "请输入数字")
                return
            }
            if Float(stockAmount.text!) == nil{
                showMsgbox(_message: "请输入数字")
                return
            }
            if Float(fundAmount.text!) == nil{
                showMsgbox(_message: "请输入数字")
                return
            }
            if Float(bondAmount.text!) == nil{
                showMsgbox(_message: "请输入数字")
                return
            }
            
            //检查各个信息栏是否为空,以及数据类型是否符合要求
            if cashAmount.text == ""{
                //检查现金是否为空
                showMsgbox(_message: "请输入现金金额")
                
                return
                
            }else if stockAmount.text == ""{
                //检查股票是否为空
                showMsgbox(_message: "请输入股票金额")
                
                return
                
            }else if fundAmount.text == ""{
                //检查基金是否为空
                showMsgbox(_message: "请输入基金金额")
                
                return
                
            }else if bondAmount.text == ""{
                //检查债券是否为空
                showMsgbox(_message: "请输入债券金额")
                
                return
            }
            
            print("计算")
            //计算资产比例
            if cashAmount.text != "" {
                cashString = cashAmount.text!
                cashFloat = Float(cashString)!
                print(cashAmount.text)
            }
            if stockAmount.text != "" {
                stockString = stockAmount.text!
                stockFloat = Float(stockString)!
            }
            if fundAmount.text != "" {
                fundString = fundAmount.text!
                fundFloat = Float(fundString)!
            }
            if bondAmount.text != "" {
                bondString = bondAmount.text!
                bondFloat = Float(bondString)!
            }
            var sum: Float = 0.0
            sum =  cashFloat + stockFloat + fundFloat + bondFloat
            
            print(sum)
            cashRatio = cashFloat / sum
            stockRatio = stockFloat / sum
            fundRatio = fundFloat / sum
            bondRatio = bondFloat / sum
            
            //数据库操作
            equity = realm.objects(Equity.self).filter("user_id == %@ AND type == 'cash'", userId)
            try! realm.write {
                equity![0].amount = cashFloat
                equity![0].ratio =  cashRatio
            }
            
            equity = realm.objects(Equity.self).filter("user_id == %@ AND type == 'stock'", userId)
            try! realm.write {
                equity![0].amount = stockFloat
                equity![0].ratio =  stockRatio
            }
            
            equity = realm.objects(Equity.self).filter("user_id == %@ AND type == 'bond'", userId)
            try! realm.write {
                equity![0].amount = bondFloat
                equity![0].ratio =  bondRatio
            }
            
            equity = realm.objects(Equity.self).filter("user_id == %@ AND type == 'fund'", userId)
            try! realm.write {
                equity![0].amount = fundFloat
                equity![0].ratio =  fundRatio
            }
            
            delegate?.UpdateUI()
            dismiss(animated: true, completion: nil)
            return
            
            
        }
        
        
        //检查各个信息栏是否为空,以及数据类型是否符合要求
        if cashAmount.text == ""{
            //检查现金是否为空
            showMsgbox(_message: "请输入现金金额")
            
            return
            
        }else if stockAmount.text == ""{
            //检查股票是否为空
            showMsgbox(_message: "请输入股票金额")
            
            return
            
        }else if fundAmount.text == ""{
            //检查基金是否为空
            showMsgbox(_message: "请输入基金金额")
            
            return
            
        }else if bondAmount.text == ""{
            //检查债券是否为空
            showMsgbox(_message: "请输入债券金额")
            
            return
        }
        
        print("计算")
        //计算资产比例
        if cashAmount.text != "" {
            cashString = cashAmount.text!
            cashFloat = Float(cashString)!
            print(cashAmount.text)
        }
        if stockAmount.text != "" {
            stockString = stockAmount.text!
            stockFloat = Float(stockString)!
        }
        if fundAmount.text != "" {
            fundString = fundAmount.text!
            fundFloat = Float(fundString)!
        }
        if bondAmount.text != "" {
            bondString = bondAmount.text!
            bondFloat = Float(bondString)!
        }
        var sum: Float = 0.0
        sum =  cashFloat + stockFloat + fundFloat + bondFloat
        
        print(sum)
        cashRatio = cashFloat / sum
        stockRatio = stockFloat / sum
        fundRatio = fundFloat / sum
        bondRatio = bondFloat / sum
        
        print("数据库")
        saveEquityInfor()
        print("传完了")
        
        //获取根VC
        var rootVC = self.presentingViewController
        while let parent = rootVC?.presentingViewController {
            rootVC = parent
        }
        //释放所有下级视图
        rootVC?.dismiss(animated: true, completion: nil)
    }
    
    //显示弹出窗信息
    func showMsgbox(_message: String, _title: String = "提示"){
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertController.Style.alert)
        let btnOK = UIAlertAction(title: "好的", style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    //将资产信息写入数据库
    func saveEquityInfor() {
        //cash
        print("1")
        var equity = Equity()
        
        equity.id = realm.objects(Equity.self).count + 1
        equity.user_id = userId//传值
        equity.type = "cash"
        equity.amount = cashFloat
        equity.ratio = cashRatio
        
        //print("equity datebase: ", Realm.Configuration.defaultConfiguration.fileURL!)
        
        do{
            let realm = try Realm()
            try realm.write{
                realm.add(equity)
                print("2")
            }
        }catch{
            print(error)
            print("3")
        }
        
        //stock
        equity = Equity()
        equity.id = realm.objects(Equity.self).count + 1
        equity.user_id = userId//需要传值
        equity.type = "stock"
        equity.amount = stockFloat
        equity.ratio = stockRatio
        
        print("equity datebase: ", Realm.Configuration.defaultConfiguration.fileURL!)
        
        do{
            let realm1 = try Realm()
            try realm1.write{
                realm1.add(equity)
                print("4")
            }
        }catch{
            print(error)
            print("5")
        }
        
        //fund
        equity = Equity()
        equity.id = realm.objects(Equity.self).count + 1
        equity.user_id = userId//需要传值
        equity.type = "fund"
        equity.amount = fundFloat
        equity.ratio = fundRatio
        
        print("equity datebase: ", Realm.Configuration.defaultConfiguration.fileURL!)
        
        do{
            let realm2 = try Realm()
            try realm2.write{
                realm2.add(equity)
            }
        }catch{
            print(error)
        }
        //bond
        equity = Equity()
        equity.id = realm.objects(Equity.self).count + 1
        equity.user_id = userId//需要传值
        equity.type = "bond"
        equity.amount = bondFloat
        equity.ratio = bondRatio
        
        print("equity datebase: ", Realm.Configuration.defaultConfiguration.fileURL!)
        
        do{
            let realm3 = try Realm()
            try realm3.write{
                realm3.add(equity)
                print("yes")
            }
        }catch{
            print(error)
        }
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
