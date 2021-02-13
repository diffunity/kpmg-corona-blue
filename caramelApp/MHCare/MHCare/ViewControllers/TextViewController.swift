//
//  TextViewController.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/06.
//

import UIKit
import Charts

class TextViewController: UIViewController {

    
    @IBOutlet weak var combinedChartView: CombinedChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var pieChartOuterView: UIView!
    @IBOutlet weak var pieChartTabView: UIView!
    
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var positiveCircle: UIView!
    @IBOutlet weak var negativeCircle: UIView!
    
    @IBOutlet weak var positiveLabel: UILabel!
    @IBOutlet weak var negativeLabel: UILabel!
    
    
    @IBOutlet weak var horizontalBarChartView: HorizontalBarChartView!
    
    
    @IBOutlet weak var horizontalBarChartTabView: UIView!
    
    @IBOutlet weak var horizontalBarChartOuterView: UIView!
    
    let lightColor = UIColor(displayP3Red: 131/255, green: 182/255, blue: 255/255, alpha: 1.0)
    let darkColor = UIColor(displayP3Red: 66/255, green: 56/255, blue: 242/255, alpha: 1.0)

    
    var graphArray: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let bardata1 = [10.0, 17.0, 9.0, 1.0, 8.0, 13.0, 16.0]
    let bardata2 = [12.0, 20.0, 14.0, 5.0, 16.0, 15.0, 20.0]

    let linedata = [10.0, 17.0, 9.0, 1.0, 8.0, 13.0, 16.0]
    
    // Pie Chart
    let emotions = ["Positive", "Negative"]
    let unitsSold = [34.0, 66.0]
    
    
    // Radar Chart
    let subjects = ["Happy", "Sadness", "Surprise", "Fear", "Anger", "Disgust", "Neutral" ]
    let array = [60.0, 50.0, 10.0, 10.0, 40.0, 30.0, 70.0]
    
    // Horizontal Bar Chart
    let wordList = ["tired", "lonely", "lost", "regret", "happy"]
    let wordcount = [20.0, 15.0, 10.0, 5.0, 5.0]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        combinedChart(dataPoints: graphArray, barValues: bardata1, barValues2: bardata2, lineValues: linedata)


        // Pie Chart
        pieChart(dataPoints: emotions, values: unitsSold)

        // Radar Chart
        
        // Horizontal Bar Chart
        horizontalBarChart(dataPoints: wordList, barValues: wordcount)
        // Do any additional setup after loading the view.
    }
    
    func setPieChartUI() {
        pieChartOuterView.clipsToBounds = false
        pieChartOuterView.layer.shadowColor = UIColor.black.cgColor
        pieChartOuterView.layer.shadowOpacity = 0.1
        pieChartOuterView.layer.shadowOffset = CGSize(width: 0, height: 10)
        pieChartOuterView.layer.shadowRadius = 15
        
        pieChartTabView.clipsToBounds = true
        pieChartTabView.layer.cornerRadius = 15
        
        pieChartOuterView.addSubview(pieChartTabView)
        
        
        
        positiveCircle.layer.cornerRadius = positiveCircle.bounds.height/2
        positiveCircle.layer.masksToBounds = true
        negativeCircle.layer.cornerRadius = positiveCircle.bounds.height/2
        negativeCircle.layer.masksToBounds = true
        
        positiveLabel.text = String(unitsSold[0]) + "%"
        negativeLabel.text = String(unitsSold[1]) + "%"
        
        if unitsSold[0] < unitsSold[1] {
            levelLabel.textColor = darkColor
            levelLabel.text = "High"
        } else {
            levelLabel.textColor = lightColor
            levelLabel.text = "Low"
        }

    }
    
    func setHorizontalBarChartUI() {
        horizontalBarChartOuterView.clipsToBounds = false
        horizontalBarChartOuterView.layer.shadowColor = UIColor.black.cgColor
        horizontalBarChartOuterView.layer.shadowOpacity = 0.1
        horizontalBarChartOuterView.layer.shadowOffset = CGSize(width: 0, height: 10)
        horizontalBarChartOuterView.layer.shadowRadius = 15
        
        horizontalBarChartTabView.clipsToBounds = true
        horizontalBarChartTabView.layer.cornerRadius = 15
        
        horizontalBarChartOuterView.addSubview(horizontalBarChartTabView)
    }
    
    
    func combinedChart(dataPoints: [String], barValues: [Double],barValues2: [Double], lineValues: [Double]) {
        combinedChartView.noDataText = "You need to provide data for the chart."
        // bar, line 엔트리 생성
        var barDataEntries: [BarChartDataEntry] = []
        var lineDataEntries: [ChartDataEntry] = []
        
        // bar, line 엔트리 삽입
        for i in 0..<dataPoints.count {
            let barDataEntry = BarChartDataEntry(x: Double(i), yValues: [barValues[i], barValues2[i]])
            let lineDataEntry = ChartDataEntry(x: Double(i), y: lineValues[i])
            barDataEntries.append(barDataEntry)
            lineDataEntries.append(lineDataEntry)
        }

        // 데이터셋 생성
        let barChartDataSet = BarChartDataSet(entries: barDataEntries, label: "일일 우울지수")
        let lineChartDataSet = LineChartDataSet(entries: lineDataEntries, label: "일일 우울")
 
        
        
        // 데이터 생성
        let data: CombinedChartData = CombinedChartData()
        
        // bar 데이터 지정
        data.barData = BarChartData(dataSet: barChartDataSet)
        // line 데이터 지정
        data.lineData = LineChartData(dataSet: lineChartDataSet)
        
        // combined 데이터 지정
        combinedChartView.data = data
        
        
        // 여기서부터는 그래프 예쁘게 수정하는 내용
        // 전체
        // X축 데이터 설정
        combinedChartView.xAxis.axisMaximum = data.xMax + 0.25
        combinedChartView.xAxis.axisMinimum = data.xMin - 0.25
        
        // X축 레이블 포맷 ( index -> 실제데이터 )
        combinedChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: graphArray)
        
        // 배경 그리드 라인 그릴지 여부
        combinedChartView.xAxis.drawGridLinesEnabled = false
        combinedChartView.leftAxis.drawGridLinesEnabled = false
        combinedChartView.backgroundColor = .white
        // 리미트 라인 생성 (평균 라인)
        //combinedChartView.leftAxis.addLimitLine(ChartLimitLine(limit: 10, label: "평균"))
        
        // 우측 레이블 제거
        combinedChartView.rightAxis.enabled = false
        
        // X축 레이블 위치 조정
        combinedChartView.xAxis.labelPosition = .bottom
        combinedChartView.leftAxis.axisMinimum = 0
        combinedChartView.rightAxis.axisMinimum = 0
        
        // legend
        let l = combinedChartView.legend
        l.wordWrapEnabled = true
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false


        
        // line chart
        // 라인 굵기
        lineChartDataSet.lineWidth = 4.5
        
        // 라인 및 라인 원 색깔 변경
        lineChartDataSet.colors = [UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)]
        lineChartDataSet.circleColors = [UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)]
        
        // 원 구멍 반경
        lineChartDataSet.circleHoleRadius = 5.0

        // 원 반경 (꽉채우려면 홀 반경이랑 똑같게)
        lineChartDataSet.circleRadius = 5.0
        lineChartDataSet.mode = .cubicBezier
        // 라인 차트에 대한 value값 보이게 할 건지
        lineChartDataSet.drawValuesEnabled = false
        
        
        // bar chart
        // 바 컬러, 바 두께
        barChartDataSet.colors = [UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1),  UIColor.systemGray5]

        let barWidth = 0.3
        data.barData.barWidth = barWidth
        

        
        // 차트 선택 되게 할지 여부
        lineChartDataSet.highlightEnabled = false
        barChartDataSet.highlightEnabled = true
        barChartDataSet.axisDependency = .left
        // 줌 안되게
        
        combinedChartView.doubleTapToZoomEnabled = false

        // 애니메이션 효과
        // 기본 애니메이션
        combinedChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        // 옵션 애니메이션
        //combinedChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
    }
    
    func pieChart(dataPoints: [String], values: [Double]) {
        pieChartView.noDataText = "You need to provide data for the chart."
        
        setPieChartUI()
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry1 = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i])
            dataEntries.append(dataEntry1)
        }
      
        let pieChartDataSet = PieChartDataSet(entries: dataEntries)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        pieChartView.data = pieChartData
        pieChartView.centerText = ""
    
        // 랜덤 컬러 지정
        var colors: [UIColor] = [lightColor, darkColor]
        
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
    
    func horizontalBarChart(dataPoints: [String], barValues: [Double]) {
        
        setHorizontalBarChartUI()
        
        // bar, line 엔트리 생성
        var barDataEntries: [BarChartDataEntry] = []
        
        // bar, line 엔트리 삽입
        for i in 0..<barValues.count {
            let barDataEntry = BarChartDataEntry(x: Double(i), y: barValues[i])
            barDataEntries.append(barDataEntry)
        }
        
        
        // 데이터 생성
        let barWidth = 0.5
        let horizonChartDataSet = BarChartDataSet(entries: barDataEntries)
        
        horizonChartDataSet.drawIconsEnabled = true
        horizonChartDataSet.colors = [NSUIColor.green]
        horizonChartDataSet.drawValuesEnabled = true
        
        let horizonChartData = BarChartData(dataSet: horizonChartDataSet)
        horizonChartData.barWidth = barWidth
        
        
        horizontalBarChartView.data =  horizonChartData
        horizontalBarChartView.drawBarShadowEnabled = false
        horizontalBarChartView.drawValueAboveBarEnabled = true

        
        horizontalBarChartView.drawGridBackgroundEnabled = false
        horizontalBarChartView.xAxis.drawGridLinesEnabled = false
        horizontalBarChartView.leftAxis.drawGridLinesEnabled = false
        
        horizontalBarChartView.xAxis.labelPosition = .bottom
        horizontalBarChartView.xAxis.labelTextColor = UIColor.black
        horizontalBarChartView.xAxis.drawLabelsEnabled = true
        horizontalBarChartView.xAxis.labelCount = 5
        

        
        
        horizontalBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        horizontalBarChartView.setExtraOffsets(left: 40.0, top: 30.0, right: 50.0, bottom: 30.0)
        horizontalBarChartView.legend.enabled = false
        horizontalBarChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        horizontalBarChartView.doubleTapToZoomEnabled = false
    }

    

}
