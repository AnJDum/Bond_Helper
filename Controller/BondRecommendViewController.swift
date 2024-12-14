//
//  BondRecommendViewController.swift
//  Bond_Helper
//


import UIKit
import RealmSwift

protocol BondRecommendDelegate {
    func jumpToHomePage()
}
struct BondScore {
    var bond: RealmBond
    var score: Float = 0.0
}
class BondRecommendViewController: UIViewController {
    var userarray = [Int]() //用户列表
    var bondquantity: Int = 4 //债券数量
    var userquantity = 1  //用户数量
    var bondDict = [String: Int]() //债券字典
    var userDict = [Int: Int]() //用户字典
    var counter = 1 //债券计数器：已被用户购买债券信息数量
    var counterUser = 1 //用户计数器：已添加债券信息用户数量
    var delegate: BondRecommendDelegate?
    var currentUser = ""
    var userId = 0
    //数据库操作
    var equity: Results<Equity>?
    var users: Results<User>?
    var bonds: Results<RealmBond>?
    let realm = try! Realm()
    var simarray = [[Float]]()
    @IBOutlet weak var safeBondNamw: UILabel!
    @IBAction func backToMyInfor(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func toHomePage(_ sender: Any) {
        
         dismiss(animated: true, completion: nil)
         delegate?.jumpToHomePage()
        
    }
    @IBOutlet weak var recBond1: UILabel!
    @IBOutlet weak var recBond2: UILabel!
    @IBOutlet weak var recBond3: UILabel!
    @IBOutlet weak var recBond4: UILabel!
    @IBOutlet weak var recBond5: UILabel!
    @IBOutlet weak var recBond6: UILabel!
    @IBOutlet weak var recRate1: UILabel!
    @IBOutlet weak var recRate2: UILabel!
    @IBOutlet weak var recRate3: UILabel!
    @IBOutlet weak var recRate4: UILabel!
    @IBOutlet weak var recRate5: UILabel!
    @IBOutlet weak var recRate6: UILabel!
    
    @IBOutlet weak var cashTrend: UILabel!
    @IBOutlet weak var cashRecommend: UILabel!
    @IBOutlet weak var riskTrend: UILabel!
    @IBOutlet weak var riskRecommend: UILabel!
    @IBOutlet weak var bondRecommend: UILabel!
    @IBOutlet weak var bondTrend: UILabel!
    
    @IBOutlet weak var riskGrade: UILabel!
    @IBOutlet weak var rationRecommend: UILabel!
    
    var cashOri: Results<Equity>?
    var stockOri: Results<Equity>?
    var fundOri: Results<Equity>?
    var bondOri: Results<Equity>?
    var sum: Float = 0.0
    var cashDiff: Float = 0.0
    var sfDiff: Float = 0.0
    var bondDiff: Float = 0.0
    var Diff: Float = 0.0
    var scores:[Float] = []
    var newScores:[BondScore] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        1. 构建合理分配
        cash:(stock+fund):bond
        "保守型" 6:1:3
        "相对保守型" 5:1:4
        "稳健型" 4:2:4
        "相对积极型" 4:3:3
        "积极型" 3:3:4

        2. 在债券中选择合适的
        interest:risk
        */
        
        // 读取现有
        let rationDict:[String:String] = ["保守型":"6:1:3", "相对保守型":"5:1:4", "稳健型":"4:2:4","相对积极型":"4:3:3","积极型" :"3:3:4"]
        cashOri = realm.objects(Equity.self).filter("user_id  == %@", userId).filter("type == 'cash'")
        stockOri = realm.objects(Equity.self).filter("user_id  == %@", userId).filter("type == 'stock'")
        fundOri = realm.objects(Equity.self).filter("user_id  == %@", userId).filter("type == 'fund'")
        bondOri = realm.objects(Equity.self).filter("user_id  == %@", userId).filter("type == 'bond'")
        users = realm.objects(User.self).filter("id  == %@", userId)

        //计算合理资产
        riskGrade.text = users![0].riskGrade
        rationRecommend.text = rationDict[users![0].riskGrade]
        if users![0].riskGrade == "保守型"{
            sum = cashOri![0].amount + stockOri![0].amount + fundOri![0].amount + bondOri![0].amount
            cashDiff = 0.6 * sum - cashOri![0].amount
            sfDiff = 0.1 * sum - (stockOri![0].amount + fundOri![0].amount)
            bondDiff = 0.3 * sum - bondOri![0].amount
        }
        else if users![0].riskGrade == "相对保守型"{
            sum = cashOri![0].amount + stockOri![0].amount + fundOri![0].amount + bondOri![0].amount
            cashDiff = 0.5 * sum - cashOri![0].amount
            sfDiff = 0.1 * sum - (stockOri![0].amount + fundOri![0].amount)
            bondDiff = 0.4 * sum - bondOri![0].amount
        }
        else if users![0].riskGrade == "稳健型"{
            sum = cashOri![0].amount + stockOri![0].amount + fundOri![0].amount + bondOri![0].amount
            cashDiff = 0.4 * sum - cashOri![0].amount
            sfDiff = 0.2 * sum - (stockOri![0].amount + fundOri![0].amount)
            bondDiff = 0.4 * sum - bondOri![0].amount
        }
        else if users![0].riskGrade == "相对积极型"{
            sum = cashOri![0].amount + stockOri![0].amount + fundOri![0].amount + bondOri![0].amount
            cashDiff = 0.4 * sum - cashOri![0].amount
            sfDiff = 0.3 * sum - (stockOri![0].amount + fundOri![0].amount)
            bondDiff = 0.3 * sum - bondOri![0].amount
        }
        else{
            sum = cashOri![0].amount + stockOri![0].amount + fundOri![0].amount + bondOri![0].amount
            cashDiff = 0.3 * sum - cashOri![0].amount
            sfDiff = 0.3 * sum - (stockOri![0].amount + fundOri![0].amount)
            bondDiff = 0.4 * sum - bondOri![0].amount
        }

       // let twoDecimalPlaces = String(format: "%.2f", 10.426123)

        //打印建议
        cashRecommend.text = sugPrint(_diff: cashDiff)
        riskRecommend.text =  sugPrint(_diff: sfDiff)
        bondRecommend.text =  sugPrint(_diff: bondDiff)
        // 颜色
        
        if cashDiff > 0{
            cashRecommend.textColor = UIColor(red: 149/225, green: 68/225, blue: 43/225, alpha: 1)
            cashTrend.text = "增加"
            cashTrend.textColor = UIColor(red: 149/225, green: 68/225, blue: 43/225, alpha: 1)
        }
        else if cashDiff < 0{
            cashRecommend.textColor = UIColor(red: 62/225, green: 101/225, blue: 112/225, alpha: 1)
            cashTrend.text = "减少"
            cashTrend.textColor = UIColor(red: 62/225, green: 101/225, blue: 112/225, alpha: 1)
        }
        else if cashDiff == 0{
            cashTrend.text = "不需要变化"
            cashTrend.textColor = UIColor(red: 43/225, green: 64/225, blue: 131/225, alpha: 1)
        }
        
        if sfDiff > 0{
            riskRecommend.textColor =        UIColor(red: 149/225, green: 68/225, blue: 43/225, alpha: 1)
            riskTrend.text = "增加"
            riskTrend.textColor = UIColor(red: 149/225, green: 68/225, blue: 43/225, alpha: 1)
        }
        else if sfDiff < 0{
            riskRecommend.textColor = UIColor(red: 62/225, green: 101/225, blue: 112/225, alpha: 1)
            riskTrend.text = "减少"
            riskTrend.textColor = UIColor(red: 62/225, green: 101/225, blue: 112/225, alpha: 1)
        }
        else if sfDiff == 0{
            riskTrend.text = "不需要变化"
            riskTrend.textColor = UIColor(red: 43/225, green: 64/225, blue: 131/225, alpha: 1)
        }
        
        
        if bondDiff > 0{
            bondRecommend.textColor =        UIColor(red: 149/225, green: 68/225, blue: 43/225, alpha: 1)
            bondTrend.text = "增加"
                    bondTrend.textColor = UIColor(red: 149/225, green: 68/225, blue: 43/225, alpha: 1)}
        else if bondDiff < 0{
            bondRecommend.textColor = UIColor(red: 62/225, green: 101/225, blue: 112/225, alpha: 1)
            bondTrend.text = "减少"
                       bondTrend.textColor = UIColor(red: 43/225, green: 64/225, blue: 131/225, alpha: 1)
        }
        else if bondDiff == 0{
            bondTrend.text = "不需要变化"
            bondTrend.textColor = UIColor(red: 43/225, green: 64/225, blue: 131/225, alpha: 1)
           
        }
        
        //推荐国债
        recommendBond(riskGrade: users![0].riskGrade)
        
        
    }
    func recommendBond(riskGrade:String){
        var defaultRisk :Float =  20.0//麦考利久期的设定值，久期越大，风险越大,取了一个较大的值，测试集中比更大的数还大一点
//        var defaultYield :Float = 0.0//利率的设定值
        var riskPrefer :Float = 2.0
        var yieldPrefer :Float = 1.0
        bonds = realm.objects(RealmBond.self)
        if riskGrade == "保守型"{//喜欢风险很小
            riskPrefer = 4.0
            yieldPrefer = 1.0
            for value in bonds!{
                let x = defaultRisk-value.MacDur
                let y = value.interestRate
                scores.append(riskPrefer*x*x+yieldPrefer*y*y)//打分高，说明越喜好
    
            }
        }
        else if riskGrade == "相对保守型"{
            riskPrefer = 3.0
            yieldPrefer = 2.0
            for value in bonds!{
                let x = defaultRisk-value.MacDur
                let y = value.interestRate
                scores.append(riskPrefer*x*x+yieldPrefer*y*y)//打分高，说明越喜好
            }
        }
        else if riskGrade == "稳健型"{
            riskPrefer = 2.5
            yieldPrefer = 2.5
            for value in bonds!{
                let x = defaultRisk-value.MacDur
                let y = value.interestRate
                scores.append(riskPrefer*x*x+yieldPrefer*y*y)//打分高，说明越喜好
            }
        }
        else if riskGrade == "相对积极型"{
            riskPrefer = 2.0
            yieldPrefer = 3.0
            for value in bonds!{
                let x = defaultRisk-value.MacDur
                let y = value.interestRate
                scores.append(riskPrefer*x*x+yieldPrefer*y*y)//打分高，说明越喜好
            }
        }
        else{
            riskPrefer = 1.0
            yieldPrefer = 4.0
            for value in bonds!{
                let x = defaultRisk-value.MacDur
                let y = value.interestRate
                scores.append(riskPrefer*x*x+yieldPrefer*y*y)//打分高，说明越喜好
            }
        }
        let u = scoreMean()
        let v = scoreDelta(mean:u)
        var index = 0
        calculate()//根据用户的相似性计算。
        print(bondDict)
        
        users = realm.objects(User.self).filter("id  == %@", userId)
        var curUserBond : Results<UserBond>?
        curUserBond = realm.objects(UserBond.self).filter("user_id == %@",users![0].id)
        var canRecommend = false
        if !curUserBond!.isEmpty {//说明用户添加了自己的债券，做同质化推荐
            let temp1 = bondDict[curUserBond!.last!.bondName]
            print("最新一个用户添加的债券是")
            print(temp1)
            canRecommend = true
        }
        
        let weightOfUser = (users!.count<1000 ? Double(users!.count)/1000 : 1)
        for value in scores{
            var valueToZ = (value - u)/v    //z-sccore化标准化处理，将硬指标定好了
            if canRecommend {
                if bondDict.keys.contains(bonds![index].name){
                    let temp1 = bondDict[curUserBond!.last!.bondName]!
                    print(bondDict[bonds![index].name]!)
                    valueToZ += Float(weightOfUser) * simarray[bondDict[bonds![index].name]!-1][temp1-1]
                }
            }
                
            newScores.append(BondScore(bond: bonds![index], score: valueToZ))
            index+=1
        }
        newScores.sort { (s1, s2) -> Bool in
            s1.score>s2.score
        }
        
        var rank = 1//看第几个recBond
        var flag = false
        for curIndex in 0...newScores.count-1{
            if newScores[curIndex].bond.dueDate > "2020"{//如果到期日期大于2020
                if newScores[curIndex].bond.code.count == 6{
                    switch rank {
                    case 1:
                        recBond1.text = newScores[curIndex].bond.name
                        recRate1.text = "\(newScores[curIndex].bond.interestRate)"+"%"
                    case 2:
                        recBond2.text = newScores[curIndex].bond.name
                        recRate2.text = "\(newScores[curIndex].bond.interestRate)"+"%"
                    case 3:
                        recBond3.text = newScores[curIndex].bond.name
                        recRate3.text = "\(newScores[curIndex].bond.interestRate)"+"%"
                    case 4:
                        recBond4.text = newScores[curIndex].bond.name
                        recRate4.text = "\(newScores[curIndex].bond.interestRate)"+"%"
                    case 5:
                        recBond5.text = newScores[curIndex].bond.name
                        recRate5.text = "\(newScores[curIndex].bond.interestRate)"+"%"
                    case 6:
                        recBond6.text = newScores[curIndex].bond.name
                        recRate6.text = "\(newScores[curIndex].bond.interestRate)"+"%"
                    default: break
                    }
                    rank += 1
                }
                else if flag == false{
                    safeBondNamw.text = newScores[curIndex].bond.name
                    flag = true
                }
            }
        }

            
    }
    //在页面上方显示建议
    func scoreMean()->Float{
        var Mysum :Float = 0.0
        for i in 0...scores.count-1{
            Mysum += scores[i]
        }
        return Mysum/Float(scores.count)
    }
    func scoreDelta(mean:Float) -> Float {
        var sumUp :Float = 0.0
        for i in 0...scores.count-1{
            sumUp += (scores[i]-mean)*(scores[i]-mean)
            
        }
        sumUp = sumUp/Float(scores.count)
        return sqrt(sumUp)
    }
    func sugPrint(_diff: Float)->String{
        if _diff < 0{
            return(String(format: "%.2f", abs(_diff)) + "万")
        }
        else if _diff == 0{
            return("")
        }
        else{
            return(String(format: "%.2f", abs(_diff)) + "万")
        }
    }
    
    
    func calculate(){
        var userBond: Results<UserBond>?
        let realm2 = try! Realm()
        userBond = realm2.objects(UserBond.self)
        if (userBond!.isEmpty)
        {
            print("用户没添加债券")
            return
        }
        print(userBond![0].user_id)
        
        print("计算已经填过债券信息的用户数量")
        for i in 0...userBond!.count-1{
            userarray.append(userBond?[i].user_id ?? 0)
        }
        print(userarray)
        let userset = Set(userarray) //集合
        userquantity = userset.count
        print(userquantity)
        
        
        print("将债券信息放入字典中")
        bondDict[userBond?[0].bondName ?? "wu"] = counter
        print("infor:\(userBond!.count)")
        for i in 1...userBond!.count-1{
            
            print(userBond?[i].bondName ?? "wu")
            var flag = 0
            for key in bondDict.keys{
                if userBond?[i].bondName == key{
                    flag = flag + 1
                }
            }
            if flag < 1{
                
                counter = counter + 1
                bondDict[userBond?[i].bondName ?? "wu"] = counter
                flag = 0
            }
        }
        
        print("将已填写债券用户id放入字典中")
        userDict[userBond?[0].user_id ?? 100] = counterUser
        print("infor:\(userBond!.count)")
        for i in 1...userBond!.count-1{
            
            print(userBond?[i].user_id ?? 100)
            var flag = 0
            for key in userDict.keys{
                if userBond?[i].user_id == key{
                    flag = flag + 1
                }
            }
            if flag < 1{
                
                counterUser = counterUser + 1
                userDict[userBond?[i].user_id ?? 100] = counterUser
                flag = 0
            }
        }

        
        print(bondDict)
        bondquantity = bondDict.count
        
//        print(userBond![0].user_id)
//        print(userBond![0].bondName)
//        print(userBond![0].amount)
//        print(userBond![1].user_id)
//        print(userBond![1].bondName)
//        print(userBond![1].amount)
        
        
        print("将数据库中数据读取成float型二维数组")
        var realmarray = [[Float]]()
      //  print(userBond!.count-1)
        for i in 0...userBond!.count-1{
            realmarray.append([0,0,0])
        }
        print("初始全0表")
        print(realmarray)

        var basearray = [[Float]]()
        let user = [Float](repeating: 0, count: Int(bondquantity))
        for index in 1...userquantity{
            basearray.append(user)
        }
        for i in 0...userBond!.count-1{
            print(i)
            print(userBond![i].user_id)
            print(userBond![i].bondName)
            print(userBond![i].amount)
            realmarray[i][0] = Float(userDict[userBond![i].user_id] ?? 0)
            realmarray[i][1] =  Float(bondDict[userBond![i].bondName] ?? 0)
            realmarray[i][2] = Float(userBond![i].amount)
        }
        print("转化完毕数据表")
        print(realmarray)
        print("here:\(realmarray.count)")
        
        print("将初始数据表转化为算法所需要的表")
        for i in 0...realmarray.count-1{
            var a = Int(realmarray[i][0])
            var b = Int(realmarray[i][1])
            basearray[a-1][b-1] = Float(realmarray[i][2])
        }
        
        print("转化完毕")
        print(basearray)
        
        
        //计算simiarity

        
        for index in 1...bondquantity{
            simarray.append(user)
        }
        
        print(simarray)
        for i in 0...bondquantity-1{
            for j in i...bondquantity-1{
                var sum1 = 0.0
                var sum2 = 0.0
                var sum3 = 0.0
                for z in 0...userquantity-1{
                    sum1 = sum1 + Double(basearray[z][i]*basearray[z][j])
                    sum2 = sum2 + Double(basearray[z][i]*basearray[z][i])
                    sum3 = sum3 + Double(basearray[z][j]*basearray[z][j])
                }

                simarray[i][j] = Float(sum1/((sqrt(sum2)*sqrt(sum3))))
                simarray[j][i] = Float(sum1/((sqrt(sum2)*sqrt(sum3))))
            }
        }
        print("计算simiarity")
        print(simarray)
        
    }

    
}
