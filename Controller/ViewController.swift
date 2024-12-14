//
//  ViewController.swift
//  Bond_Helper
//

import RealmSwift
import UIKit
import PagingMenuController

protocol ViewControllerDelegate {
    func jumpToRecommend()
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var delegate: ViewControllerDelegate?
    
    //数据库操作
    var bond: Results<RealmBond>?
    let realm = try! Realm()
    
    @IBOutlet weak var bondTable: UITableView!
    @IBOutlet weak var fnews: UIImageView!

    
    @IBAction func firstNewsChange(_ sender: Any) {
        fnews.image = UIImage(named:"fnews1.png")
    }
    
    
    @IBAction func secNewsChange(_ sender: Any) {
        fnews.image = UIImage(named:"fnews2.png")
    }
    
    @IBAction func thirdNewsChange(_ sender: Any) {
        fnews.image = UIImage(named:"fnews3.png")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //自适应调整table cell的高度
        //        self.bondTable.estimatedRowHeight = 100
        //        self.bondTable.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        bond = realm.objects(RealmBond.self)
        
        
    }
    
    @IBAction func StabilityRank(_ sender: Any) {
        //数据库操作
        bond = realm.objects(RealmBond.self).sorted(byKeyPath: "duration", ascending: false)
        
        self.bondTable.reloadData();
    }
    
    @IBAction func riskRank(_ sender: Any) {
        
        //数据库操作
        bond = realm.objects(RealmBond.self).sorted(byKeyPath: "MacDur", ascending: false)
        
        self.bondTable.reloadData();
    }
    
    @IBAction func interestRateRank(_ sender: Any) {
        
        //数据库操作
        bond = realm.objects(RealmBond.self).sorted(byKeyPath: "interestRate", ascending: false)
        
        self.bondTable.reloadData();
        
    }
    
    
    // MARK: - Table view data source
    
    @IBAction func backToMyInfor(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toRecommend(_ sender: Any) {
         dismiss(animated: true, completion: nil)
          delegate?.jumpToRecommend()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bond!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bond", for: indexPath) as! BondCell
        cell.bondName?.text = bond![indexPath.row].name
        cell.interestRate?.text = "\(bond![indexPath.row].interestRate)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("editing")
        if !isEditing{
            //取消cell的择状态（也就是把底色去掉）--固定用法
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBond"{
            let vc = segue.destination as! BondDetails
            let cell = sender as! BondCell
            let row = bondTable.indexPath(for: cell)!.row
            vc.newCode = bond![row].code
            vc.newName = bond![row].name
            vc.newOriginator = bond![row].originator
            vc.newQuantity = Double(bond![row].quantity)//精度问题
            vc.newDuration = Double(bond![row].duration)//精度问题
            vc.newPrice = Double(bond![row].price)
            vc.newInterestRate = Double(bond![row].interestRate)
            vc.newDescri = bond![row].descri
            vc.newFrequency = Double(bond![row].frequency)
            vc.newReleaseDate = bond![row].releaseDate
            vc.newLaunchDate = bond![row].launchDate
            vc.newPaymentNote = bond![row].paymentNote
            vc.newDueDate = bond![row].dueDate
            vc.newGuarantor = bond![row].guarantor
            vc.newAssureMean = bond![row].assureMean
            vc.newIndustry = bond![row].industry
            vc.newPledgeCode = bond![row].pledgeCode
//            vc.delegate = self
        }
        
    }
    
    //此处省略引用声明
    //通过委托来实现放弃第一响应者
    //UITextField Delegate Method
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //通过委托来实现放弃第一响应者
    //UITextView Delegate  Method
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

/*class User: Object{
 @objc dynamic var userName: String = ""
 @objc dynamic var userPassWord: String = ""
 @objc dynamic var userMail: String = ""
 @objc dynamic var userBirth: String = ""
 }*/
