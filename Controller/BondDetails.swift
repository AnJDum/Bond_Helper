//
//  BondDetails.swift
//  Bond_Helper
//

import UIKit

protocol BondInfo {
    func getBondName(BondName:String)
}   //自定义BondInfo的delegate是为了从ViewController传送Bond的名字信息

class BondDetails: UIViewController {
    
    //获取主界面传来的信息值
    
    var newCode = ""
    var newName = ""
    var newOriginator = ""
    var newDescri = ""
    var newFrequency = 1.0
    var newPrice = 100.0
    var newInterestRate = 1.1
    var newDuration = 1.0
    var newQuantity = 10.0
    var newIndustry = ""
    var newPledgeCode = ""
    var newAssureMean = ""
    var newGuarantor = ""
    var newDueDate = ""
    var newPaymentNote = ""
    var newLaunchDate = ""
    var newReleaseDate = ""
//    var delegate : BondInfo?
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var originator: UILabel!
    @IBOutlet weak var descri: UILabel!
//    @IBOutlet weak var frequency: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var interestRate: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var industry: UILabel!
    @IBOutlet weak var pledgeCode: UILabel!
    @IBOutlet weak var assureMean: UILabel!
    @IBOutlet weak var guarantor: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var paymentNote: UILabel!
    @IBOutlet weak var launchDate: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        code.text = "\(newCode)"
        name.text = newName
        originator.text = newOriginator
        descri.text = newDescri
       // frequency.text = "\(newFrequency)"
        price.text = "\(newPrice)"
        interestRate.text = "\(newInterestRate)"
        duration.text = "\(newDuration)"
        quantity.text = "\(newQuantity)"
        industry.text = newIndustry
        pledgeCode.text = newPledgeCode
        assureMean.text = newAssureMean
        guarantor.text = newGuarantor
        dueDate.text = newDueDate
        paymentNote.text = newPaymentNote
        launchDate.text = newLaunchDate
        releaseDate.text = newReleaseDate
    }
    //返回按键
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //实现登录界面和用户信息界面的正向传值
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Get the new view controller using segue.destination.
           // Pass the selected object to the new view controller.
           if segue.identifier == "toCFGraph"{
               let vc = segue.destination as! GraphViewController
               vc.bondCode = newCode
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
