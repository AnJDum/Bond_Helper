//
//  ChartController.swift
//  Bond_Helper
//


import UIKit
import AAInfographics
import RealmSwift

class ChartController: UIViewController {
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var userId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //从数据库中查找
        var equity: Results<Equity>?
        //var users: Results<User>?
        let realm = try! Realm()
        
        equity = realm.objects(Equity.self).filter("user_id == %@ AND type == 'cash'", userId)
        let cashAmount = equity![0].amount
//        let cashRatio = String(equity![0].ratio)
        
        equity = realm.objects(Equity.self).filter("user_id == %@ AND type == 'stock'", userId)
        let stockAmount = equity![0].amount
//        let stockRatio = String(equity![0].ratio)
        
        equity = realm.objects(Equity.self).filter("user_id == %@ AND type == 'bond'", userId)
        let bondAmount = equity![0].amount
//        let bondRatio = String(equity![0].ratio)
        
        equity = realm.objects(Equity.self).filter("user_id == %@ AND type == 'fund'", userId)
        let fundAmount = equity![0].amount
//        let fundRatio = String(equity![0].ratio)
        
        // 初始化图表视图控件
        let chartWidth  = self.view.frame.size.width
        let chartHeight = self.view.frame.size.height - 150
        let aaChartView = AAChartView()
        aaChartView.frame = CGRect(x:0, y:0, width:chartWidth, height:chartHeight)
        self.view.addSubview(aaChartView)
        
        // 初始化图表模型
        let chartModel = AAChartModel()
            .chartType(.pie) //图表类型
            .title("资产占比统计")//图表主标题
            .subtitle(date2String(Date()))//图表副标题
            .inverted(false)//是否翻转图形
            .dataLabelsEnabled(true)//是否直接显示扇形图数据
            .series(
                [
                    AASeriesElement()
                        .name("数额")
                        .allowPointSelect(false)
                        .data([
                            ["现金", cashAmount],
                            ["股票", stockAmount],
                            ["基金", bondAmount],
                            ["债券", fundAmount],
                        ])
                        .toDic()!,
                ]
        )
        
        // 图表视图对象调用图表模型对象,绘制最终图形
        aaChartView.aa_drawChartWithChartModel(chartModel)
        
        // Do any additional setup after loading the view.
    }
    
    
    //日期 -> 字符串
    func date2String(_ date:Date, dateFormat:String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
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
