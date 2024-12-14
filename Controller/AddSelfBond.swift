//
//  AddSelfBond.swift
//  Bond_Helper
//

import UIKit
import RealmSwift
protocol editUserBond {
    func didAddUserBond(bondName:String)
}
class AddSelfBond: UIViewController {
    var currentBond = UserBond()
    var delegete : editUserBond?
    let realm = try! Realm()
    var searchBond : Results<RealmBond>?
    var repeatBond : Results<UserBond>?
    var currentUserId:Int = 0
    @IBOutlet weak var setBondName: UITextField!
    @IBOutlet weak var setBondAmount: UITextField!
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setBondName.resignFirstResponder()
        setBondAmount.resignFirstResponder()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func confirm(_ sender: Any) {
        if (setBondName.text == ""){
            showMsgbox(_message: "请输入债券名")
            return
        }
        if (setBondAmount.text == "") {
            showMsgbox(_message: "请输入购买份额")
            return
        }
        if (Double(setBondAmount.text!) != nil){
            let amount = Double(setBondAmount.text!)!
            if (amount <= 0) {
                showMsgbox(_message: "输入购买份额不得小于0")
                return
            }
            
        }
        else {
            showMsgbox(_message: "请输入数字")
            return
        }

        searchBond = realm.objects(RealmBond.self).filter("name == %@", setBondName.text!)
        if(searchBond!.isEmpty){
            showMsgbox(_message: "该债券不存在，请重新输入")
            return
        }
        else{
            repeatBond = realm.objects(UserBond.self).filter("bondName == %@",setBondName.text!)
            var userRepeat = 0//初始值默认没选过该债券
            
            if repeatBond!.count != 0{
                
                
                for i in 0...(repeatBond!.count-1){
                    if repeatBond![i].user_id == currentUserId{
                        userRepeat = userRepeat + 1 //说明自己已经添加过同样债券
                    }
                }
                if (userRepeat>=1){
                    showMsgbox(_message: "你已经选过该债券，请左滑删除重新增加")
                    return
                }
            }
            currentBond.amount = Double(setBondAmount.text!)!
            currentBond.bondName = setBondName.text!
            currentBond.user_id = currentUserId
            try! realm.write{
                realm.add(currentBond)
            }
        }
        delegete?.didAddUserBond(bondName: currentBond.bondName)
        dismiss(animated: true, completion: nil)
        return
    }
    func showMsgbox(_message: String, _title: String = "提示"){
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertController.Style.alert)
        let btnOK = UIAlertAction(title: "好的", style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
    
}
