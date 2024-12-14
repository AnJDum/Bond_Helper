import UIKit
import RealmSwift


class LoginController: UIViewController {
    
    //获取用户登录信息
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    //退出登录后注销界面
    @IBAction func loginDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //载入界面
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //数据库操作
    var users: Results<User>?
    let realm = try! Realm()
    
    //点击登录按钮
    @IBAction func loginButton(_ sender: Any) {
        //检查各个信息栏是否为空
        if userName.text == ""{
            //检查用户名是否为空
            showMsgbox(_message: "请输入用户名")
            
            return
            
        }else if userPassword.text == ""{
            //检查密码是否为空
            showMsgbox(_message: "请设置登录密码")
            
            return
            
        }
        
        
        //检查用户登录信息
        users = realm.objects(User.self).filter("name CONTAINS %@", userName.text)
        
        if(users!.isEmpty){
            //用户名是否存在
            showMsgbox(_message: "用户名不存在")
            return
        }else if(users![0].password != userPassword.text){
            //密码是否错误
            showMsgbox(_message: "登录密码错误")
            return
        }
        
        
        //showMsgbox(_message: "登录成功")
        self.performSegue(withIdentifier: "login", sender: self)
        
    }
    
    
    //实现登录界面和用户信息界面的正向传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "login"{
            let vc = segue.destination as! MyInformationController
            vc.currentUser = userName.text!
        }
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
        userName.resignFirstResponder()
        userPassword.resignFirstResponder()

    }
}

