//
//  QuestionController.swift
//  Bond_Helper
//


import UIKit
import RealmSwift

class QuestionController: UIViewController {
    
    //数据库操作
    var users: Results<User>?
    let realm = try! Realm()
    
    //存储用户信息
    var user = User()
    
    
    let QuestionNumer = 12
    let questions = [
        question(text: "1. 请问您的年龄处于：", Answer1score: 3, Answer2score: 7, Answer3score: 9, Answer4score: 5, Answer5score: 1, Answer1text: "A．30岁以下；", Answer2text: "B．31-40岁；", Answer3text: "C．41-50岁；", Answer4text: "D．51-60岁；", Answer5text: "E．60岁以上。",quesnum: 5),
        question(text: "2.您家庭预计进行证券投资的资金占家庭现有总资产(不含自住、自用房产及汽车等固定资产)的比例是：", Answer1score: 1, Answer2score: 3, Answer3score: 5, Answer4score:7 , Answer5score:9 , Answer1text: "A．70%以上；", Answer2text: "B．50%-70% ", Answer3text: "C．30%－50%；", Answer4text: "D．10%－30%；", Answer5text: "E．10%以下。",quesnum: 5),
        question(text: "3.进行一项重大投资后，您通常会觉得：", Answer1score: 9, Answer2score: 7, Answer3score: 5, Answer4score: 3, Answer5score: 1, Answer1text: "A．很高兴，对自己的决定很有信心；", Answer2text: "B．轻松，基本持乐观态度；", Answer3text: "C．基本没什么影响；", Answer4text: "D．比较担心投资结果；", Answer5text: "E．非常担心投资结果。", quesnum: 5),
        question(text: "4.如果您需要把大量现金整天携带在身的话，您是否会感到：", Answer1score: 1, Answer2score: 3, Answer3score: 7, Answer4score: 0, Answer5score: 0, Answer1text: "A．非常焦虑；", Answer2text: "B．有点焦虑；", Answer3text: "C．完全不会焦虑。", Answer4text: " ", Answer5text: " ",quesnum: 3),
        question(text: "5. 当您独自到外地游玩，遇到三岔路口，您会选择：", Answer1score: 3, Answer2score: 5, Answer3score: 7, Answer4score: 9, Answer5score: 0, Answer1text: "A．仔细研究地图和路标 ；", Answer2text: "B．找别人问路；", Answer3text: "C．大致判断一下方向 ；", Answer4text: "D．也许会用掷骰子的方式来做决定。", Answer5text: " ", quesnum: 4),
        question(text: "6.假设有两种不同的投资：投资A预期获得5%的收益，有可能承担非常小的损失；投资B预期获得20%的收益，但有可能面临25%甚至更高的亏损。您将您的投资资产分配为：", Answer1score: 0, Answer2score: 3, Answer3score: 5, Answer4score: 7, Answer5score: 9, Answer1text: "A．全部投资于A；", Answer2text: "B．大部分投资于A；", Answer3text: "C．两种投资各一半；", Answer4text: "D．大部分投资于B；", Answer5text: "E．全部投资于B。", quesnum: 5),
        question(text: "7. 假如您前期用25元购入一只股票，该股现在升到30元，而根据预测该股近期有一半机会升到35元，另一半机会跌到25元，您现在会", Answer1score: 0, Answer2score: 3, Answer3score: 5, Answer4score: 7, Answer5score: 0, Answer1text: "A．立刻卖出；", Answer2text: "B．部分卖出；", Answer3text: "C．继续持有；", Answer4text: "D．继续买入。", Answer5text: " ", quesnum: 4),
        question(text: "8.同上题情况，该股现在已经跌到20元，而您估计该股近期有一半机会升回25元，另一半机会继续下跌到15元，您现在会：", Answer1score: 0, Answer2score: 3, Answer3score: 5, Answer4score: 7, Answer5score: 0, Answer1text: "A．立刻卖出；", Answer2text: "B．部分卖出；", Answer3text: "C．继续持有；", Answer4text: "D．继续买入。", Answer5text: " ", quesnum: 4),
        question(text: "9.当您进行投资时，您的首要目标是：", Answer1score: 1, Answer2score: 5, Answer3score: 7, Answer4score: 9, Answer5score: 0, Answer1text: "A．资产保值，我不愿意承担任何投资风险", Answer2text: "B．尽可能保证本金安全，不在乎收益率比较低；", Answer3text: "C．产生较多的收益，可以承担一定的投资风险；", Answer4text: "D．实现资产大幅增长，愿意承担很大的投资风险。", Answer5text: " ", quesnum: 4),
        question(text: "10.您的投资经验可以被概括为：", Answer1score: 1, Answer2score: 3, Answer3score: 7, Answer4score: 9, Answer5score: 0, Answer1text: "A．有限：除银行活期账户和定期存款外，我基本没有其他投资经验；", Answer2text: "B．一般：除银行活期账户和定期存款外，我购买过基金、保险等理财产品，但还需要进一步的指导；", Answer3text: "C．丰富：我是一位有经验的投资者，参与过股票、基金等产品的交易，并倾向于自己做出投资决策；", Answer4text: "D．非常丰富：我是一位非常有经验的投资者，参与过权证、期货或创业板等高风险产品的交易。", Answer5text: " ", quesnum: 4),
        question(text: "11.您是否了解证券市场的相关知识：", Answer1score: 1, Answer2score: 3, Answer3score: 7, Answer4score: 9, Answer5score: 0, Answer1text: "A．从来没有参与过证券交易，对投资知识完全不了解；", Answer2text: "B．学习过证券投资知识，但没有实际操作经验，不懂投资技巧；", Answer3text: "C．了解证券市场的投资知识，并且有过实际操作经验，懂得一些投资技巧；", Answer4text: "D．参与过多年的证券交易，投资知识丰富，具有一定的专业水平。", Answer5text: " ", quesnum: 4),
        question(text: "12.您用于证券投资的资金不会用作其它用途的时间段为：", Answer1score: 1, Answer2score: 5, Answer3score: 7, Answer4score: 0, Answer5score: 0, Answer1text: "A．短期——0到1年；", Answer2text: "B．中期——1到5年；", Answer3text: "C．长期——5年以上。", Answer4text: " ", Answer5text: " ", quesnum: 3)
        
    ]
    
    var questionNum = 0
    
    @IBOutlet weak var questionlabel: UILabel!
    
    @IBOutlet weak var choice1: UIButton!
    @IBOutlet weak var choice2: UIButton!
    @IBOutlet weak var choice3: UIButton!
    @IBOutlet weak var choice4: UIButton!
    @IBOutlet weak var choice5: UIButton!
    
    var sumScore = 0
    var end_question = 0
    @IBAction func answerPressed(_ sender: UIButton) {
        
    

        if sender.tag == 1{
            sumScore += questions[questionNum].answerscore[0]
            print(sumScore)

        }else if sender.tag == 2{
            sumScore += questions[questionNum].answerscore[1]
            print(sumScore)

        }else if sender.tag == 3{
            sumScore += questions[questionNum].answerscore[2]
            print(sumScore)
            
        }else if sender.tag == 4{
            if questions[questionNum].questionnum <= 3{
                questionNum = questionNum - 1
            }else{
                sumScore += questions[questionNum].answerscore[3]
                print(sumScore)
            }
        }else{
            if questions[questionNum].questionnum <= 4{
                questionNum = questionNum - 1
            }else{
                sumScore += questions[questionNum].answerscore[4]
                print(sumScore)
            }
            

        }
        
        questionNum = questionNum + 1
       
        
        if questionNum <= QuestionNumer-1{
            questionlabel.text = questions[questionNum].questionText
            choice1.setTitle(questions[questionNum].answer[0], for: .normal)
            choice2.setTitle(questions[questionNum].answer[1], for: .normal)
            choice3.setTitle(questions[questionNum].answer[2], for: .normal)
            choice4.setTitle(questions[questionNum].answer[3], for: .normal)
            choice5.setTitle(questions[questionNum].answer[4], for: .normal)
        }else{
            print("meile")
//            questionNum = 0
            
            //var riskGrade: String
            if sumScore >= 11 && sumScore <= 24{
                user.riskGrade = "保守型"
            }else if sumScore >= 25 && sumScore <= 36{
                user.riskGrade = "相对保守型"
            }else if sumScore >= 37 && sumScore <= 72{
                user.riskGrade = "稳健型"
            }else if sumScore >= 73 && sumScore <= 86{
                user.riskGrade = "相对积极型"
            }else{
                user.riskGrade = "积极型"
            }
            
            
            print(Realm.Configuration.defaultConfiguration.fileURL)
            do{
                let realm = try Realm()
                try realm.write{
                    realm.add(user)
                }
            }catch{
                print(error)
            }

            self.performSegue(withIdentifier: "toEquity", sender: self)
            
        }
        
    }
    
    
    
    //实现登录界面和用户信息界面的正向传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toEquity"{
            let vc = segue.destination as! EquityController
            vc.userId = user.id
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionlabel.text = questions[0].questionText
        choice1.setTitle(questions[0].answer[0], for: .normal)
        choice2.setTitle(questions[0].answer[1], for: .normal)
        choice3.setTitle(questions[0].answer[2], for: .normal)
        choice4.setTitle(questions[0].answer[3], for: .normal)
        choice5.setTitle(questions[0].answer[4], for: .normal)
        
    }
    
    func showMsgbox(_message: String, _title: String){
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertController.Style.alert)
        let btnOK = UIAlertAction(title: "好的", style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    
//    @IBAction func enterEquity(_ sender: Any) {
//
//            if questionNum != QuestionNumer{
//                showMsgbox(_message: "你的问卷还没有作答完成，无法进入下一步",_title: "提示")
//                return
//            }else{
//
//                self.performSegue(withIdentifier: "toEquity", sender: self)
//            }
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

