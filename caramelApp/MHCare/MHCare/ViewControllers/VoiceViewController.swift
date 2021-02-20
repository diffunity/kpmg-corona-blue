//
//  VoiceViewController.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/06.
//

import UIKit
import Charts
import ConcentricProgressRingView

class VoiceViewController: UIViewController {

    @IBOutlet weak var toneButton: UIButton!
    @IBOutlet weak var contentButton: UIButton!
    
    
    @IBOutlet weak var toneScrollView: UIScrollView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    @IBOutlet weak var overallOuterView: UIView!
    @IBOutlet weak var overallView: UIView!
    
    @IBOutlet weak var pieChartOuterView: UIView!
    @IBOutlet weak var pieChartTabView: UIView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    
    @IBOutlet weak var circleChartView: UIView!
    
    
    @IBOutlet weak var combinedTabOuterView: UIView!
    @IBOutlet weak var combinedTabView: UIView!
    
    
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var horizontalBarChartOuterView: UIView!
    @IBOutlet weak var horizontalBarChartTabView: UIView!
    @IBOutlet weak var horizontalBarChartView: HorizontalBarChartView!
    
    @IBOutlet weak var radarChartOuterView: UIView!
    @IBOutlet weak var radarChartTabView: UIView!
    
    @IBOutlet weak var radarChartView: RadarChartView!
    
    
    @IBOutlet weak var toneOverallOuterView: UIView!
    @IBOutlet weak var toneOverallTabView: UIView!
    
    @IBOutlet weak var tonePieChartOuterView: UIView!
    @IBOutlet weak var tonePieChartTabView: UIView!
    @IBOutlet weak var tonePieChartView: PieChartView!
    
    
    @IBOutlet weak var toneCircleChartView: UIView!
    
    
    @IBOutlet weak var toneCombinedChartOuterView: UIView!
    @IBOutlet weak var toneCombinedChartTabView: UIView!

    

    @IBOutlet weak var toneBarChartView: BarChartView!
    
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
    
    let circlevalues = [0.8]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toneButton.alpha = 0.3
        contentButton.alpha = 1.0
        contentScrollView.isHidden = false
        toneScrollView.isHidden = true
        
        setOverallTabUI()
        setHorizontalBarChartUI()

        // Do any additional setup after loading the view.
        circleChart(Values: circlevalues)
        barChart(dataPoints: graphArray, barValues: bardata1)

        radarChart(dataPoints: subjects, values: array)


    }
    
    
    @IBAction func toneToggled(_ sender: Any) {
        if toneScrollView.isHidden {
            
            setToneOverallTabUI()
            toneBarChart(dataPoints: graphArray, barValues: bardata1)
            toneCircleChart(Values: circlevalues)
            
            
            contentButton.alpha = 0.3
            toneButton.alpha = 1.0
            contentScrollView.isHidden = true
            toneScrollView.isHidden = false
        }
    }
    
    @IBAction func contentToggled(_ sender: Any) {
        if contentScrollView.isHidden {
            
            setOverallTabUI()

            // Do any additional setup after loading the view.
            circleChart(Values: circlevalues)
            barChart(dataPoints: graphArray, barValues: bardata1)
            radarChart(dataPoints: subjects, values: array)
            
            toneButton.alpha = 0.3
            contentButton.alpha = 1.0
            toneScrollView.isHidden = true
            contentScrollView.isHidden = false
        }
    }
    
    func setOverallTabUI() {
        overallOuterView.clipsToBounds = false
        overallOuterView.layer.shadowColor = UIColor.black.cgColor
        overallOuterView.layer.shadowOpacity = 0.1
        overallOuterView.layer.shadowOffset = CGSize(width: 0, height: 10)
        overallOuterView.layer.shadowRadius = 15
        
        overallView.clipsToBounds = true
        overallView.layer.cornerRadius = 15
        
        overallOuterView.addSubview(overallView)
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
        
        

    }
    
    func setCombinedChartUI() {
        combinedTabOuterView.clipsToBounds = false
        combinedTabOuterView.layer.shadowColor = UIColor.black.cgColor
        combinedTabOuterView.layer.shadowOpacity = 0.1
        combinedTabOuterView.layer.shadowOffset = CGSize(width: 0, height: 10)
        combinedTabOuterView.layer.shadowRadius = 15
        
        combinedTabView.clipsToBounds = true
        combinedTabView.layer.cornerRadius = 15
        
        combinedTabOuterView.addSubview(combinedTabView)
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
    
    func setRadarChartUI() {
        radarChartOuterView.clipsToBounds = false
        radarChartOuterView.layer.shadowColor = UIColor.black.cgColor
        radarChartOuterView.layer.shadowOpacity = 0.1
        radarChartOuterView.layer.shadowOffset = CGSize(width: 0, height: 10)
        radarChartOuterView.layer.shadowRadius = 15
        
        radarChartTabView.clipsToBounds = true
        radarChartTabView.layer.cornerRadius = 15
        
        radarChartOuterView.addSubview(radarChartTabView)
    }
    
    
    func circleChart(Values: [Double]){
        setPieChartUI()
        let fgColor1 = darkColor
        let bgColor1 = UIColor.systemGray5
        let rings = [
            ProgressRing(color: fgColor1, backgroundColor: bgColor1, width: 15),
            //ProgressRing(color: fgColor2, backgroundColor: bgColor2, width: 20),
            //ProgressRing(color: fgColor3, backgroundColor: bgColor2, width: 20),
        ]
        let margin: CGFloat = 2
        let radius: CGFloat = 70
        let progressRingView = ConcentricProgressRingView(center: circleChartView.center, radius: radius, margin: margin, rings: rings)
        progressRingView.arcs[0].setProgress(CGFloat(Values[0]), duration: 2)
        //progressRingView.arcs[1].setProgress(0.8, duration: 2)
        //progressRingView.arcs[2].setProgress(0.4, duration: 2)

        circleChartView.addSubview(progressRingView)
        
//        let horizontalConstraint = NSLayoutConstraint(item: progressRingView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: circleChartView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
//        let verticalConstraint = NSLayoutConstraint(item: progressRingView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: circleChartView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
//        circleChartView.addConstraints([horizontalConstraint, verticalConstraint])
    }
    
    func barChart(dataPoints: [String], barValues: [Double]) {
        setCombinedChartUI()
        barChartView.noDataText = "You need to provide data for the chart."
        // bar, line 엔트리 생성
        var barDataEntries: [BarChartDataEntry] = []

        // bar, line 엔트리 삽입
        for i in 0..<dataPoints.count {
            let barDataEntry = BarChartDataEntry(x: Double(i), y: barValues[i])
            barDataEntries.append(barDataEntry)

        }

        // 데이터셋 생성
        let barChartDataSet = BarChartDataSet(entries: barDataEntries, label: "일일 우울지수")
   
        
        // bar 데이터 지정
        let data = BarChartData(dataSet: barChartDataSet)
        
        // combined 데이터 지정
        barChartView.data = data
//        let font2 =  UIFont.init(name: "Open Sans", size: 10.0)!
//        barChartView.data!.setValueFont(font2)
        barChartView.data!.setValueTextColor(UIColor.systemGray2)
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))

        
        // 여기서부터는 그래프 예쁘게 수정하는 내용
        // 전체
        // X축 데이터 설정
        barChartView.xAxis.axisMaximum = data.xMax + 0.25
        barChartView.xAxis.axisMinimum = data.xMin - 0.25
        barChartView.xAxis.drawAxisLineEnabled = false

        // X축 레이블 포맷 ( index -> 실제데이터 )
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: graphArray)
//        let font =  UIFont.init(name: "Open Sans", size: 13.0)!
//        barChartView.xAxis.labelFont = font

        // 배경 그리드 라인 그릴지 여부
        barChartView.xAxis.drawGridLinesEnabled = false
   
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.backgroundColor = .white
        barChartView.drawBarShadowEnabled = false

        // 우측 레이블 제거
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.enabled = false
        
        
        // X축 레이블 위치 조정
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelTextColor = UIColor.systemGray
        barChartView.leftAxis.axisMinimum = 0
        barChartView.rightAxis.axisMinimum = 0
        
        
        // legend
        barChartView.legend.enabled = false

        
        // bar chart
        // 바 컬러, 바 두께

        let G = UIColor(red: 0.4471, green: 1, blue: 0.8157, alpha: 1.0)
        barChartDataSet.colors = [lightColor, lightColor, lightColor, lightColor, lightColor, lightColor,darkColor ]

        let barWidth = 0.5
        data.barWidth = barWidth
        barChartDataSet.barShadowColor = UIColor.systemGray6
        barChartDataSet.highlightEnabled = false
        barChartDataSet.axisDependency = .left
        // 줌 안되게
        
        barChartView.doubleTapToZoomEnabled = false

        // 애니메이션 효과
        // 기본 애니메이션
        //combinedChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        // 옵션 애니메이션
        barChartView.animate(yAxisDuration: 2.0, easingOption: .easeInBounce)
        barChartView.drawMarkers = true
        barChartView.marker = ChartMarker()
        barChartView.setExtraOffsets(left: 30.0, top: 0.0, right: 30.0, bottom: 15.0)
    }
    
//    func horizontalBarChart(dataPoints: [String], barValues: [Double]) {
//
//        setHorizontalBarChartUI()
//
//        // bar, line 엔트리 생성
//        var barDataEntries: [BarChartDataEntry] = []
//
//        // bar, line 엔트리 삽입
//        for i in 0..<barValues.count {
//            let barDataEntry = BarChartDataEntry(x: Double(i), y: barValues[i])
//            barDataEntries.append(barDataEntry)
//        }
//
//
//        // 데이터 생성
//        let barWidth = 0.5
//        let horizonChartDataSet = BarChartDataSet(entries: barDataEntries)
//
//        horizonChartDataSet.drawIconsEnabled = true
//        horizonChartDataSet.colors = [NSUIColor.green]
//        horizonChartDataSet.drawValuesEnabled = true
//
//        let horizonChartData = BarChartData(dataSet: horizonChartDataSet)
//        horizonChartData.barWidth = barWidth
//
//
//        horizontalBarChartView.data =  horizonChartData
//        horizontalBarChartView.drawBarShadowEnabled = false
//        horizontalBarChartView.drawValueAboveBarEnabled = true
//
//
//        horizontalBarChartView.drawGridBackgroundEnabled = false
//        horizontalBarChartView.xAxis.drawGridLinesEnabled = false
//        horizontalBarChartView.leftAxis.drawGridLinesEnabled = false
//
//        horizontalBarChartView.xAxis.labelPosition = .bottom
//        horizontalBarChartView.xAxis.labelTextColor = UIColor.black
//        horizontalBarChartView.xAxis.drawLabelsEnabled = true
//        horizontalBarChartView.xAxis.labelCount = 5
//
//
//
//
//        horizontalBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
//        horizontalBarChartView.setExtraOffsets(left: 40.0, top: 30.0, right: 50.0, bottom: 30.0)
//        horizontalBarChartView.legend.enabled = false
//        horizontalBarChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
//        horizontalBarChartView.doubleTapToZoomEnabled = false
//    }
    
    func radarChart(dataPoints: [String], values: [Double]) {
        setRadarChartUI()

        radarChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = RadarChartDataEntry(value: values[i], data: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        let RadarchartDataSet = RadarChartDataSet(entries: dataEntries, label: "Units Sold")
        
        let data3: RadarChartData = RadarChartData(dataSet: RadarchartDataSet)

        
        // 데이터 지정
        radarChartView.data = data3
  
        //Options of radarChart
        radarChartView.sizeToFit()

        //Options for the axis from here. The range is 0-100, the interval is 20
        radarChartView.yAxis.labelCount = 7
        //RadarChartView.yAxis.axisMinValue = 0.0
        //RadarChartView.yAxis.axisMaxValue = 100.0

        radarChartView.rotationEnabled = false
        RadarchartDataSet.drawFilledEnabled = true
        
        // value formatter
        RadarchartDataSet.valueFormatter = DataSetValueFormatter()

        //Other options
        radarChartView.legend.enabled = false
        radarChartView.yAxis.gridAntialiasEnabled = true
        radarChartView.animate(yAxisDuration: 2.0)
        
        let xAxis = radarChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 9, weight: .bold)
        xAxis.labelTextColor = .black
        xAxis.xOffset = 10
        xAxis.yOffset = 10
        xAxis.valueFormatter = XAxisFormatter()

        // 여백 지정
        radarChartView.setExtraOffsets(left: 30.0, top: 30.0, right: 30.0, bottom: 30.0)
    }
    
    func setToneOverallTabUI() {
        toneOverallOuterView.clipsToBounds = false
        toneOverallOuterView.layer.shadowColor = UIColor.black.cgColor
        toneOverallOuterView.layer.shadowOpacity = 0.1
        toneOverallOuterView.layer.shadowOffset = CGSize(width: 0, height: 10)
        toneOverallOuterView.layer.shadowRadius = 15
        
        toneOverallTabView.clipsToBounds = true
        toneOverallTabView.layer.cornerRadius = 15
        
        toneOverallOuterView.addSubview(toneOverallTabView)
    }
    
    
    func setTonePieChartUI() {
        tonePieChartOuterView.clipsToBounds = false
        tonePieChartOuterView.layer.shadowColor = UIColor.black.cgColor
        tonePieChartOuterView.layer.shadowOpacity = 0.1
        tonePieChartOuterView.layer.shadowOffset = CGSize(width: 0, height: 10)
        tonePieChartOuterView.layer.shadowRadius = 15
        
        tonePieChartTabView.clipsToBounds = true
        tonePieChartTabView.layer.cornerRadius = 15
        
        tonePieChartOuterView.addSubview(tonePieChartTabView)
        
        

    }
    
    func setToneCombinedChartUI() {
        toneCombinedChartOuterView.clipsToBounds = false
        toneCombinedChartOuterView.layer.shadowColor = UIColor.black.cgColor
        toneCombinedChartOuterView.layer.shadowOpacity = 0.1
        toneCombinedChartOuterView.layer.shadowOffset = CGSize(width: 0, height: 10)
        toneCombinedChartOuterView.layer.shadowRadius = 15
        
        toneCombinedChartTabView.clipsToBounds = true
        toneCombinedChartTabView.layer.cornerRadius = 15
        
        toneCombinedChartOuterView.addSubview(toneCombinedChartTabView)
    }
    

    
    func toneCircleChart(Values: [Double]){
        setTonePieChartUI()
        let fgColor1 = darkColor
        let bgColor1 = UIColor.systemGray5
        let rings = [
            ProgressRing(color: fgColor1, backgroundColor: bgColor1, width: 15),
            //ProgressRing(color: fgColor2, backgroundColor: bgColor2, width: 20),
            //ProgressRing(color: fgColor3, backgroundColor: bgColor2, width: 20),
        ]
        let margin: CGFloat = 2
        let radius: CGFloat = 70
        let progressRingView = ConcentricProgressRingView(center: toneCircleChartView.center, radius: radius, margin: margin, rings: rings)
        progressRingView.arcs[0].setProgress(CGFloat(Values[0]), duration: 2)
        //progressRingView.arcs[1].setProgress(0.8, duration: 2)
        //progressRingView.arcs[2].setProgress(0.4, duration: 2)

        toneCircleChartView.addSubview(progressRingView)
        
//        let horizontalConstraint = NSLayoutConstraint(item: progressRingView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: circleChartView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
//        let verticalConstraint = NSLayoutConstraint(item: progressRingView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: circleChartView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
//        circleChartView.addConstraints([horizontalConstraint, verticalConstraint])
    }
    
    
    func toneBarChart(dataPoints: [String], barValues: [Double]) {
        setToneCombinedChartUI()
        toneBarChartView.noDataText = "You need to provide data for the chart."
        // bar, line 엔트리 생성
        var barDataEntries: [BarChartDataEntry] = []

        // bar, line 엔트리 삽입
        for i in 0..<dataPoints.count {
            let barDataEntry = BarChartDataEntry(x: Double(i), y: barValues[i])
            barDataEntries.append(barDataEntry)

        }

        // 데이터셋 생성
        let barChartDataSet = BarChartDataSet(entries: barDataEntries, label: "일일 우울지수")
   
        
        // bar 데이터 지정
        let data = BarChartData(dataSet: barChartDataSet)
        
        // combined 데이터 지정
        toneBarChartView.data = data
//        let font2 =  UIFont.init(name: "Open Sans", size: 10.0)!
//        barChartView.data!.setValueFont(font2)
        toneBarChartView.data!.setValueTextColor(UIColor.systemGray2)
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))

        
        // 여기서부터는 그래프 예쁘게 수정하는 내용
        // 전체
        // X축 데이터 설정
        toneBarChartView.xAxis.axisMaximum = data.xMax + 0.25
        toneBarChartView.xAxis.axisMinimum = data.xMin - 0.25
        toneBarChartView.xAxis.drawAxisLineEnabled = false

        // X축 레이블 포맷 ( index -> 실제데이터 )
        toneBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: graphArray)
//        let font =  UIFont.init(name: "Open Sans", size: 13.0)!
//        barChartView.xAxis.labelFont = font

        // 배경 그리드 라인 그릴지 여부
        toneBarChartView.xAxis.drawGridLinesEnabled = false
   
        toneBarChartView.leftAxis.drawGridLinesEnabled = false
        toneBarChartView.backgroundColor = .white
        toneBarChartView.drawBarShadowEnabled = false

        // 우측 레이블 제거
        toneBarChartView.rightAxis.enabled = false
        toneBarChartView.leftAxis.enabled = false
        
        
        // X축 레이블 위치 조정
        toneBarChartView.xAxis.labelPosition = .bottom
        toneBarChartView.xAxis.labelTextColor = UIColor.systemGray
        toneBarChartView.leftAxis.axisMinimum = 0
        toneBarChartView.rightAxis.axisMinimum = 0
        
        
        // legend
        toneBarChartView.legend.enabled = false

        
        // bar chart
        // 바 컬러, 바 두께

        let G = UIColor(red: 0.4471, green: 1, blue: 0.8157, alpha: 1.0)
        barChartDataSet.colors = [lightColor, lightColor, lightColor, lightColor, lightColor, lightColor,darkColor ]

        let barWidth = 0.5
        data.barWidth = barWidth
        barChartDataSet.barShadowColor = UIColor.systemGray6
        barChartDataSet.highlightEnabled = false
        barChartDataSet.axisDependency = .left
        // 줌 안되게
        
        toneBarChartView.doubleTapToZoomEnabled = false

        // 애니메이션 효과
        // 기본 애니메이션
        //combinedChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        // 옵션 애니메이션
        toneBarChartView.animate(yAxisDuration: 2.0, easingOption: .easeInBounce)
        toneBarChartView.drawMarkers = true
        toneBarChartView.marker = ChartMarker()
        toneBarChartView.setExtraOffsets(left: 30.0, top: 0.0, right: 30.0, bottom: 15.0)
    }
}
