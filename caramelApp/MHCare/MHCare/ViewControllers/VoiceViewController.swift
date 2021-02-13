//
//  VoiceViewController.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/06.
//

import UIKit
import Charts

class VoiceViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    
    
    // Pie Chart
    let emotions = ["Positive", "Negative"]
    let unitsSold = [69.0, 31.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pieChart(dataPoints: emotions, values: unitsSold)

    }
    

    func pieChart(dataPoints: [String], values: [Double]) {
        pieChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry1 = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i])
            dataEntries.append(dataEntry1)
        }
      
        let pieChartDataSet = PieChartDataSet(entries: dataEntries)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        pieChartView.data = pieChartData
        pieChartView.centerText = "오늘의 우울지수"
    
        // 랜덤 컬러 지정
        var colors: [UIColor] = []
      
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
          
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        // 숫자 퍼센트 formatter
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
    
        // value 값 폰트 지정
        pieChartData.setValueFont(.systemFont(ofSize: 11, weight: .light))
        pieChartData.setValueTextColor(.black)
        
        // chart 컬러 설정
        pieChartDataSet.colors = colors
        
        // 애니메이션 효과
        pieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        pieChartView.legend.enabled = false

    }
    
    
}
