//
//  GraphViewController.swift
//  Bond_Helper
//


import UIKit
import AAInfographics
import RealmSwift

class GraphViewController: UIViewController {
    
    var bondCode=""
    
    let realm = try! Realm ()
    var bonds: Results<RealmBond>?
    
    var cashFuture:[Float]?//未来的支付
    var cashPresent:[Float]?//未来支付的现值
    var datePoint:[String]?//时间节点
    
    func getXTime(){
        
        if cashFuture != nil{
            datePoint = [String](repeating: "", count: cashFuture!.count)
            for i in 0...cashFuture!.count-2{
                datePoint![i] = "第\(i+1)次付息"
                
            }
            
            datePoint![cashFuture!.count-1] = "到期日\(bonds![0].dueDate)本息"
        }
    }
    
    
    
    func calculateFlow(){
        
        bonds = realm.objects(RealmBond.self).filter("code == %@", bondCode)
        let rfRates: Float = 0.0306 //市场利率
        var i: Int = 0 //每年付息次数
        let bondDur: Int = Int(bonds![0].duration) //多少年
        var duration: Float = 0.0 //久期
        var convexity: Float = 0.0 //凸度
        
        if bonds![0].paymentNote == "按半年付息"{
            i = 2
        }
        else if bonds![0].paymentNote == "按年付息"{
            i = 1
        }
        
        
        if i != 0{
            
            //"按半年付息"& "按年付息"的情况
            cashFuture = [Float](repeating: 0, count: Int(bondDur * i) + 1) //未来的支付
            cashPresent = [Float](repeating: 0, count: Int(bondDur * i) + 1) //未来支付的现值
            
            cashFuture![0] = 0 - bonds![0].price
            cashPresent![0] = 0 - bonds![0].price
            for k in 1...Int(bondDur * i) - 1{
                cashFuture![k] = bonds![0].price * bonds![0].interestRate / Float(i)/100
                cashPresent![k] = cashFuture![k] / pow((1 + rfRates / Float(i)), Float(k) )
                //                print(k,":  ",cashFuture[k])
                //                print(k,":  ",cashFuture[k])
            }
            cashFuture![Int(bondDur * i)] = bonds![0].price * (1 + bonds![0].interestRate / Float(i)/100)
            var temp: Float = pow((1 + rfRates / Float(i)), Float((bondDur * i)))
            cashPresent![Int(bondDur * i)] = cashFuture![bondDur * i] / temp
            
            //            print("8:  ",cashFuture[8])
            //            print("8:  ",cashPresent[8])
            //计算久期凸度
            var a: Float = 0.0
            var b: Float = 0.0
            var c: Float = 0.0
            
            for k in 1...Int(bondDur * i){
                a += cashPresent![k] * Float(k) / Float(i)
                b += cashPresent![k]
                c += cashPresent![k] * (Float(k) / Float(i)) * (Float(k) / Float(i))
            }
            //            print("a:  ",a)
            //            print("c:  ",c)
            //            print("b:  ",b)
            duration = a / b
            convexity = c / b
        }
        else{
            //"到期一次付息"& "其他"的情况
            //久期凸度
            duration = bonds![0].duration
            convexity = bonds![0].duration * bonds![0].duration
            //现金流
            var cashFuture = [Float](repeating: 0, count: 2)
            var cashPresent = [Float](repeating: 0, count: 2)
            cashFuture[0] = -bonds![0].price
            cashPresent[0] = -bonds![0].price
            cashFuture[1] = bonds![0].price * (1 + bonds![0].interestRate * bonds![0].duration / 100)
            cashPresent[1] = cashFuture[1] / pow((1.0 + rfRates), Float(bondDur))
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateFlow()
        
        cashPresent?.remove(at: 0)
        cashFuture?.remove(at: 0)
        
        getXTime()
        
        if datePoint != nil{
            // 初始化图表视图控件
            let chartWidth  = self.view.frame.size.width
            let chartHeight = self.view.frame.size.height - 200
            let aaChartView = AAChartView()
            aaChartView.frame = CGRect(x:0, y:0, width:chartWidth, height:chartHeight)
            self.view.addSubview(aaChartView)
            
            // 初始化图表模型
            let chartModel = AAChartModel()
                .chartType(.line)//图表类型
                .title("债券现金流图")//图表主标题
                .subtitle(date2String(Date()))//图表副标题
                //            .subtitle("LaunchDate:\(bonds![0].launchDate)  DueDate:\(bonds![0].dueDate)")//图表副标题
                .inverted(false)//是否翻转图形
                .xAxisTitle("time")// X 轴标题
                .yAxisTitle("Amount")// Y 轴标题
                .legendEnabled(true)//是否启用图表的图例(图表底部的可点击的小圆点)
                .tooltipValueSuffix("¥")//浮动提示框单位后缀
                .categories(datePoint!)
                .colorsTheme(["#fe117c","#06caf4"])//主题颜色数组,"#ffc069"
                .series([
                    AASeriesElement()
                        .name("贴现")
                        .data(cashPresent!)
                        .toDic()!,
                    AASeriesElement()
                        .name("未来")
                        .data(cashFuture!)
                        .toDic()!])
            
            // 图表视图对象调用图表模型对象,绘制最终图形
            aaChartView.aa_drawChartWithChartModel(chartModel)
            
            
        }else{
            showMsgbox(_message: "一次性还本付息，无现金流图")
            dismiss(animated: true, completion: nil)
            
        }
        
        
        
    }
    
    //日期 -> 字符串
    func date2String(_ date:Date, dateFormat:String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
    
    //显示弹出窗信息
    func showMsgbox(_message: String, _title: String = "提示"){
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertController.Style.alert)
        let btnOK = UIAlertAction(title: "好的", style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
}

