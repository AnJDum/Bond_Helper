//
//  SearchViewController.swift
//  Bond_Helper
//


import UIKit
import RealmSwift

class SearchViewController: UIViewController, UITableViewDelegate {
    

    var bondArray = [String]()
    
    //展示列表
    var tableView: UITableView!
    
    //搜索控制器
    var BondSearchController = UISearchController()
    

    //搜索过滤后的结果集
    var searchArray:[String] = [String](){
        didSet  {self.tableView.reloadData()}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建表视图
        let tableViewFrame = CGRect(x: 0, y: 20, width: self.view.frame.width,
                                    height: self.view.frame.height-20)
        self.tableView = UITableView(frame: tableViewFrame, style:.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,
                                 forCellReuseIdentifier: "MyCell")
        self.view.addSubview(self.tableView!)
        
        title = "输入债券名搜索相关信息🔍"
        //配置搜索控制器
        self.BondSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self   //两个样例使用不同的代理
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .minimal
            controller.searchBar.sizeToFit()
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        var Bond: Results<RealmBond>?
        let realm = try! Realm()
        
       
        
        Bond = realm.objects(RealmBond.self)
        
       // print(Bond![0].name)
        
        bondArray.append(Bond![0].name)
    
        for i in stride(from: 1, to: Bond!.count-1, by: 1){
            bondArray.append(Bond![i].name)
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("here")
        if segue.identifier == "ShowDetailView"{
            let vc = segue.destination as! DetailViewController
            vc.itemString = sender as? Int
//            let cell = sender as! BondCell
//            let row = tableView.indexPath(for: cell)!.row
//            let row2 = tableView.indexPathForSelectedRow
//            print(row)
//            print(row2)
//            vc.newCode = Bond![row].code
//            vc.newName = Bond![row].name
//            vc.newOriginator = Bond![row].originator
//            vc.newQuantity = Double(Bond![row].quantity)//精度问题
//            vc.newDuration = Double(Bond![row].duration)//精度问题
//            vc.newPrice = Double(Bond![row].price)
//            vc.newInterestRate = Double(Bond![row].interestRate)
//            vc.newDescri = Bond![row].descri
//            vc.newFrequency = Double(Bond![row].frequency)
//            vc.newReleaseDate = Bond![row].releaseDate
//            vc.newLaunchDate = Bond![row].launchDate
//            vc.newPaymentNote = Bond![row].paymentNote
//            vc.newDueDate = Bond![row].dueDate
//            vc.newGuarantor = Bond![row].guarantor
//            vc.newAssureMean = Bond![row].assureMean
//            vc.newIndustry = Bond![row].industry
//            vc.newPledgeCode = Bond![row].pledgeCode
//            vc.delegate = self
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

