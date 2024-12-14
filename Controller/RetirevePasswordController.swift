//
//  RetirevePasswordController.swift
//  Bond_Helper
//


import UIKit
import RealmSwift

class RetirevePasswordController: UIViewController {
    
    //载入界面
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //数据库操作
    var users: Results<User>?
    let realm = try! Realm()
    
    //在退出界面时注销界面
    @IBAction func retriveDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var userMail: UITextField!
    @IBOutlet weak var userBirth: UIDatePicker!
    
    @IBAction func checkButton(_ sender: Any) {
        
        if userMail.text == ""{
            //检查邮箱是否为空
            showMsgbox(_message: "绑定邮箱不能为空")
            
            return
            
        }
        
        //搜索绑定邮箱
        users = realm.objects(User.self).filter("mail CONTAINS %@", userMail.text)
        
        if(users!.isEmpty){
            //邮箱不存在
            showMsgbox(_message: "验证失败，没找到与该邮箱绑定的账户")
            return
        }
        
        //生日格式化
        let dformatter = DateFormatter ()
        dformatter.dateFormat = "yyyyMMdd"
        
        //开始比较
        if dformatter.string(from: (users?[0].birth)!) == dformatter.string(from: userBirth.date) {
            showMsgbox(_message:"该邮箱绑定的账号用户名：\(users![0].name)\n密码：\(users![0].password)",_title: "验证成功")
        } else {
            showMsgbox(_message: "验证失败，出生日期错误")
        }
        
        
        //        //搜索绑定的邮箱对应用户出生日期是否正确
        //        if(users![0].birth != userBirth.date){
        //            //用户出生日期不正确
        //            showMsgbox(_message: "验证失败，出生日期错误")
        //            return
        //        }
        //
        //        showMsgbox(_message:"该邮箱绑定的账号用户名：\(users![0].name)\n密码：\(users![0].password)",_title: "验证成功")
    }
    
    //显示弹出窗信息
    func showMsgbox(_message: String, _title: String = "提示"){
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertController.Style.alert)
        let btnOK = UIAlertAction(title: "好的", style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    // keyboard
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        userMail.resignFirstResponder()
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
