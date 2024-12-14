//
//  RegisterController.swift
//  Bond_Helper
//

import UIKit
import RealmSwift

class RegisterController: UIViewController {
    
    //从交互界面获取用户注册信息
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var userMail: UITextField!
    @IBOutlet weak var userBrith: UIDatePicker!
    
    @IBAction func registerDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //载入界面
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //数据库操作
    var users: Results<User>?
    let realm = try! Realm()
    
    
    //存储用户信息
    let user = User()
    
    //当用户按下确认按钮后执行的操作
    @IBAction func confirmButton(_ sender: Any) {
        
        //根据用户出生年月计算用户年龄
        let age = getAge()
        
        //检查各个信息栏是否为空,以及用户注册信息是否符合要求
        if userName.text == ""{
            //检查用户名是否为空
            showMsgbox(_message: "请输入用户名")
            
            return
            
        }else if userPassword.text == ""{
            //检查密码是否为空
            showMsgbox(_message: "请设置登录密码")
            
            return
            
        }else if confirmPassword.text == ""{
            //检查确认密码是否为空
            showMsgbox(_message: "请确认密码")
            
            return
            
        }else if userMail.text == ""{
            //检查确认邮箱是否为空
            showMsgbox(_message: "请输入邮箱")
            
            return
            
        }else if(userPassword.text != confirmPassword.text){
            //检查两次密码是否一致
            showMsgbox(_message: "两次输入的密码不一致")
            
            return
            
        }else if age < 18{
            //检查用户是否满十八岁
            showMsgbox(_message: "您不足十八岁，无法使用此软件！")
            
            return
        }
        
        
        //从数据库中查找已有用户信息，查看用户名是是否重复
        users = realm.objects(User.self).filter("name == %@", userName.text)
        if(!users!.isEmpty){
            showMsgbox(_message: "该用户名已被注册")
            return
        }
        
        //从数据库中查找已有用户信息，查看邮箱是否已被绑定
        users = realm.objects(User.self).filter("name == %@", userMail.text)
        if(!users!.isEmpty){
            showMsgbox(_message: "该邮箱已被绑定")
            return
        }
        
        //将检查过的注册信息存入user
        saveUserInfor()
        self.performSegue(withIdentifier: "toQuestionnaire", sender: self)
        
    }
    
    
    
    //显示弹出窗信息
    func showMsgbox(_message: String, _title: String = "提示"){
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertController.Style.alert)
        let btnOK = UIAlertAction(title: "好的", style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    //将注册信息写入user
    func saveUserInfor() {
        
        user.id = realm.objects(User.self).count + 1
        user.name = userName.text!
        user.password = userPassword.text!
        user.mail = userMail.text!
        user.birth = userBrith.date
        
    }
    
    //根据用户出生年月计算用户年龄
    func getAge()->Int{
        let now = Date()
        let birthday: Date = userBrith.date
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        
        return age
    }
    
    //实现登录界面和用户信息界面的正向传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toQuestionnaire"{
            let vc = segue.destination as! QuestionController
            vc.user = user
        }
    }
    // keyboard
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        userName.resignFirstResponder()
        userPassword.resignFirstResponder()
        confirmPassword.resignFirstResponder()
        userMail.resignFirstResponder()
    }
    
}

