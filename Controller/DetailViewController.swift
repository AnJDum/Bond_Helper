//
//  DetailViewController.swift
//  Bond_Helper
//


import UIKit
import RealmSwift
import Foundation

class DetailViewController: UIViewController {

    var itemString:Int?
    var Bond: Results<RealmBond>?
    let realm = try! Realm()
    
   // @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var code: UILabel!
    
    @IBOutlet weak var origin: UILabel!
    
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var duration: UILabel!
    
   // @IBOutlet weak var frequency: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var launchDate: UILabel!
    
    @IBOutlet weak var dueDate: UILabel!
    
    @IBOutlet weak var paymentNode: UILabel!
    
    @IBOutlet weak var guarantor: UILabel!
    
    @IBOutlet weak var assureMean: UILabel!
    
    @IBOutlet weak var industry: UILabel!
    
    @IBOutlet weak var pledgeCode: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      //  textField.text = "\(itemString)"
        Swift.print(itemString)
       // Bond = realm.objects(RealmBond.self)
        Bond = realm.objects(RealmBond.self).filter("index == %@",itemString! )
        name.text = Bond![0].name
     //   textField.text = Bond![0].name
        code.text = Bond![0].code
        origin.text = Bond![0].originator
        quantity.text = "\(Bond![0].quantity)"
        price.text = "\(Bond![0].price)"
        pledgeCode.text = Bond![0].pledgeCode
        duration.text = "\(Bond![0].duration)"
      //  frequency.text = "\(Bond![0].frequency)"
        releaseDate.text = Bond![0].releaseDate
        launchDate.text = Bond![0].launchDate
        dueDate.text = Bond![0].dueDate
        paymentNode.text = Bond![0].paymentNote
        guarantor.text = Bond![0].guarantor
        assureMean.text = Bond![0].assureMean
        industry.text = Bond![0].industry
    }

    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
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
