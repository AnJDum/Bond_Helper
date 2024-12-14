//
//  AddSelfBond.swift
//  Bond_Helper
//


import UIKit
import RealmSwift


class ShowSelfBond: UIViewController {


    @IBOutlet weak var bondVieww: UITableView!

    let realm = try! Realm()
    var user_id:Int = 0
    var userBonds :Results<UserBond>?
    var userBondList:[String]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        bondVieww.delegate = self
        bondVieww.dataSource = self
        bondVieww.allowsSelection = false
        // Do any additional setup after loading the view.
        userBonds = realm.objects(UserBond.self).filter("user_id == %@", user_id)
        for value in userBonds!{
            userBondList.append(value.bondName)
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addUserBond"{
            let vc = segue.destination as! AddSelfBond
            vc.currentUserId = user_id
            vc.delegete = self
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //1删除数据
            let toDelete = realm.objects(UserBond.self).filter("bondName == %@",userBondList[indexPath.row])
            try! realm.write{
                realm.delete(toDelete)
            }
            userBondList.remove(at: indexPath.row)
//            print(userBondList)
            // 2更新视图--view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
}

extension ShowSelfBond: UITableViewDelegate, UITableViewDataSource{
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userBonds?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bondVieww.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
        if (!userBonds!.isEmpty){
            cell.bondName.text = userBonds![indexPath.row].bondName
            cell.bondAmount.text = "\(userBonds![indexPath.row].amount)"
        }
        return cell
    }
}
extension ShowSelfBond: editUserBond{
    func didAddUserBond(bondName: String) {
        userBondList.append(bondName)
        print(userBondList)
        let indexPath = IndexPath(row: userBondList.count-1, section: 0)
        print("row:\(userBondList.count-1)")
        bondVieww.insertRows(at: [indexPath], with: .automatic)
    }
}
