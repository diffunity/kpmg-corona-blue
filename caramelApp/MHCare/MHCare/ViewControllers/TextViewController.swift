//
//  TextViewController.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/06.
//

import UIKit
import Charts
import ConcentricProgressRingView

class TextViewController: UIViewController {

    
    
    
    @IBOutlet weak var overallOuterView: UIView!
    @IBOutlet weak var overallView: UIView!
    
    @IBOutlet weak var combinedTabOuterView: UIView!
    @IBOutlet weak var combinedTabView: UIView!


    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var pieChartOuterView: UIView!
    @IBOutlet weak var pieChartTabView: UIView!
    

    @IBOutlet weak var horizontalBarChartView: HorizontalBarChartView!
    @IBOutlet weak var horizontalBarChartTabView: UIView!
    @IBOutlet weak var horizontalBarChartOuterView: UIView!
    
    
    @IBOutlet weak var radarChartOuterView: UIView!
    @IBOutlet weak var radarChartTabView: UIView!
    @IBOutlet weak var radarChartView: RadarChartView!
    

    @IBOutlet weak var circleChartView: UIView!
    
    
    let lightColor = UIColor(displayP3Red: 255/255, green: 196/255, blue: 211/255, alpha: 1.0)
    let darkColor = UIColor(displayP3Red: 235/255, green: 81/255, blue: 190/255, alpha: 1.0)

    
    var graphArray: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let bardata1 = [50.0, 60.0, 16.0, 78.0, 34.0, 53.0, 33.0]
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
    
    
    let circlevalues = [0.3]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setOverallTabUI()

//        combinedChart(dataPoints: graphArray, barValues: bardata1, barValues2: bardata2, lineValues: linedata)
        
        barChart(dataPoints: graphArray, barValues: bardata1)


        // Pie Chart
//        pieChart(dataPoints: emotions, values: unitsSold)
        circleChart(Values: circlevalues)

        // Radar Chart
        radarChart(dataPoints: subjects, values: array)
        setHorizontalBarChartUI()
        
        // Horizontal Bar Chart
//        horizontalBarChart(dataPoints: wordList, barValues: wordcount)
        // Do any additional setup after loading the view.
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
    
    
//    func combinedChart(dataPoints: [String], barValues: [Double],barValues2: [Double], lineValues: [Double]) {
//        setCombinedChartUI()
//        combinedChartView.noDataText = "You need to provide data for the chart."
//        // bar, line 엔트리 생성
//        var barDataEntries: [BarChartDataEntry] = []
//        var lineDataEntries: [ChartDataEntry] = []
//
//        // bar, line 엔트리 삽입
//        for i in 0..<dataPoints.count {
//            let barDataEntry = BarChartDataEntry(x: Double(i), yValues: [barValues[i], barValues2[i]])
//            let lineDataEntry = ChartDataEntry(x: Double(i), y: lineValues[i])
//            barDataEntries.append(barDataEntry)
//            lineDataEntries.append(lineDataEntry)
//        }
//
//        // 데이터셋 생성
//        let barChartDataSet = BarChartDataSet(entries: barDataEntries, label: "일일 우울지수")
//        let lineChartDataSet = LineChartDataSet(entries: lineDataEntries, label: "일일 우울")
//
//
//
//        // 데이터 생성
//        let data: CombinedChartData = CombinedChartData()
//
//        // bar 데이터 지정
//        data.barData = BarChartData(dataSet: barChartDataSet)
//        // line 데이터 지정
//        data.lineData = LineChartData(dataSet: lineChartDataSet)
//
//        // combined 데이터 지정
//        combinedChartView.data = data
//
//
//        // 여기서부터는 그래프 예쁘게 수정하는 내용
//        // 전체
//        // X축 데이터 설정
//        combinedChartView.xAxis.axisMaximum = data.xMax + 0.25
//        combinedChartView.xAxis.axisMinimum = data.xMin - 0.25
//
//        // X축 레이블 포맷 ( index -> 실제데이터 )
//        combinedChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: graphArray)
//
//        // 배경 그리드 라인 그릴지 여부
//        combinedChartView.xAxis.drawGridLinesEnabled = false
//        combinedChartView.leftAxis.drawGridLinesEnabled = false
//        combinedChartView.backgroundColor = .white
//        // 리미트 라인 생성 (평균 라인)
//        //combinedChartView.leftAxis.addLimitLine(ChartLimitLine(limit: 10, label: "평균"))
//
//        // 우측 레이블 제거
//        combinedChartView.rightAxis.enabled = false
//
//        // X축 레이블 위치 조정
//        combinedChartView.xAxis.labelPosition = .bottom
//        combinedChartView.leftAxis.axisMinimum = 0
//        combinedChartView.rightAxis.axisMinimum = 0
//
//        // legend
//        let l = combinedChartView.legend
//        l.wordWrapEnabled = true
//        l.horizontalAlignment = .center
//        l.verticalAlignment = .bottom
//        l.orientation = .horizontal
//        l.drawInside = false
//
//
//
//        // line chart
//        // 라인 굵기
//        lineChartDataSet.lineWidth = 4.5
//
//        // 라인 및 라인 원 색깔 변경
//        lineChartDataSet.colors = [UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)]
//        lineChartDataSet.circleColors = [UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)]
//
//        // 원 구멍 반경
//        lineChartDataSet.circleHoleRadius = 5.0
//
//        // 원 반경 (꽉채우려면 홀 반경이랑 똑같게)
//        lineChartDataSet.circleRadius = 5.0
//        lineChartDataSet.mode = .cubicBezier
//        // 라인 차트에 대한 value값 보이게 할 건지
//        lineChartDataSet.drawValuesEnabled = false
//
//
//        // bar chart
//        // 바 컬러, 바 두께
//        barChartDataSet.colors = [UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1),  UIColor.systemGray5]
//
//        let barWidth = 0.3
//        data.barData.barWidth = barWidth
//
//
//
//        // 차트 선택 되게 할지 여부
//        lineChartDataSet.highlightEnabled = false
//        barChartDataSet.highlightEnabled = true
//        barChartDataSet.axisDependency = .left
//        // 줌 안되게
//
//        combinedChartView.doubleTapToZoomEnabled = false
//
//        // 애니메이션 효과
//        // 기본 애니메이션
//        combinedChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
//
//        // 옵션 애니메이션
//        //combinedChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
//    }
    
    
    func pieChart(dataPoints: [String], values: [Double]) {
        setPieChartUI()
        pieChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry1 = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i])

            dataEntries.append(dataEntry1)
        }
      
        let pieChartDataSet = PieChartDataSet(entries: dataEntries)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)

        pieChartView.data = pieChartData

    
        // chart 컬러 설정
        pieChartDataSet.colors = [lightColor, darkColor]
        
        // 애니메이션 효과
        pieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        pieChartView.legend.enabled = false

        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawMarkers = true

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let centerValue :String = String( values[0])

        let centertext = NSMutableAttributedString()
        let descriptionText = NSMutableAttributedString(string: "오늘의 카라멜", attributes: [NSAttributedString.Key.foregroundColor:UIColor.systemGray2, NSAttributedString.Key.paragraphStyle: paragraph])
        let numberText =  NSMutableAttributedString(string: "\n"+centerValue, attributes: [NSAttributedString.Key.foregroundColor:UIColor.black, NSAttributedString.Key.paragraphStyle: paragraph])
        
        centertext.append(descriptionText)
        centertext.append(numberText)


        pieChartView.centerAttributedText = centertext
        
        pieChartView.marker = ChartMarker()
    }
    
    
//    func pieChart(dataPoints: [String], values: [Double]) {
//        pieChartView.noDataText = "You need to provide data for the chart."
//
//        setPieChartUI()
//        var dataEntries: [ChartDataEntry] = []
//        for i in 0..<dataPoints.count {
//            let dataEntry1 = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i])
//            dataEntries.append(dataEntry1)
//        }
//
//        let pieChartDataSet = PieChartDataSet(entries: dataEntries)
//        let pieChartData = PieChartData(dataSet: pieChartDataSet)
//
//        pieChartView.data = pieChartData
//        pieChartView.centerText = ""
//
//        // 랜덤 컬러 지정
//        let colors: [UIColor] = [lightColor, darkColor]
//
//        // 숫자 퍼센트 formatter
//        let pFormatter = NumberFormatter()
//        pFormatter.numberStyle = .percent
//        pFormatter.maximumFractionDigits = 1
//        pFormatter.multiplier = 1
//        pFormatter.percentSymbol = " %"
//        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
//
//        // value 값 폰트 지정
//        pieChartData.setValueFont(.systemFont(ofSize: 11, weight: .light))
//        pieChartData.setValueTextColor(.black)
//
//        // chart 컬러 설정
//        pieChartDataSet.colors = colors
//
//        // 애니메이션 효과
//        pieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
//        pieChartView.legend.enabled = false
//
//    }
    
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

    func radarChart(dataPoints: [String], values: [Double]) {
        
        setRadarChartUI()
        radarChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = RadarChartDataEntry(value: values[i], data: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        let RadarchartDataSet = RadarChartDataSet(entries: dataEntries, label: "Units Sold")
        
        RadarchartDataSet.drawFilledEnabled = true
        
        
        // value formatter
        RadarchartDataSet.drawValuesEnabled = false

        let data3: RadarChartData = RadarChartData(dataSet: RadarchartDataSet)

        
        // 데이터 지정
        radarChartView.data = data3
  
        //Options of radarChart
        radarChartView.sizeToFit()
        //Options for the axis from here. The range is 0-100, the interval is 20

        radarChartView.rotationEnabled = false
        radarChartView.yAxis.spaceMin = 40.0


        //Other options
        radarChartView.legend.enabled = false
        
        radarChartView.yAxis.drawLabelsEnabled = false
        radarChartView.webLineWidth = 0
        
        let chartColor = NSUIColor(cgColor: darkColor.cgColor)
        
        RadarchartDataSet.colors = [chartColor]
        RadarchartDataSet.fillColor = lightColor
        radarChartView.yAxis.drawAxisLineEnabled = false
        radarChartView.animate(yAxisDuration: 2.0)

        
        

        let xAxis = radarChartView.xAxis
//        let font2 =  UIFont.init(name: "CooperHewitt-Book", size: 10.0)!
        xAxis.labelFont = .systemFont(ofSize: 9, weight: .bold)
        xAxis.labelTextColor = .black
        xAxis.xOffset = 10
        xAxis.yOffset = 10
        xAxis.valueFormatter = XAxisFormatter()

        
        // 여백 지정
        radarChartView.setExtraOffsets(left: 15.0, top: 30.0, right: 15.0, bottom: 10.0)
    }
    
    
//    func radarChart(dataPoints: [String], values: [Double]) {
//        setRadarChartUI()
//
//        radarChartView.noDataText = "You need to provide data for the chart."
//        var dataEntries: [ChartDataEntry] = []
//        for i in 0..<dataPoints.count {
//            let dataEntry = RadarChartDataEntry(value: values[i], data: dataPoints[i])
//            dataEntries.append(dataEntry)
//        }
//        let RadarchartDataSet = RadarChartDataSet(entries: dataEntries, label: "Units Sold")
//
//        let data3: RadarChartData = RadarChartData(dataSet: RadarchartDataSet)
//
//
//        // 데이터 지정
//        radarChartView.data = data3
//
//        //Options of radarChart
//        radarChartView.sizeToFit()
//
//        //Options for the axis from here. The range is 0-100, the interval is 20
//        radarChartView.yAxis.labelCount = 7
//        //RadarChartView.yAxis.axisMinValue = 0.0
//        //RadarChartView.yAxis.axisMaxValue = 100.0
//
//        radarChartView.rotationEnabled = false
//        RadarchartDataSet.drawFilledEnabled = true
//
//        // value formatter
//        RadarchartDataSet.valueFormatter = DataSetValueFormatter()
//
//        //Other options
//        radarChartView.legend.enabled = false
//        radarChartView.yAxis.gridAntialiasEnabled = true
//        radarChartView.animate(yAxisDuration: 2.0)
//
//        let xAxis = radarChartView.xAxis
//        xAxis.labelFont = .systemFont(ofSize: 9, weight: .bold)
//        xAxis.labelTextColor = .black
//        xAxis.xOffset = 10
//        xAxis.yOffset = 10
//        xAxis.valueFormatter = XAxisFormatter()
//
//        // 여백 지정
//        radarChartView.setExtraOffsets(left: 30.0, top: 30.0, right: 30.0, bottom: 30.0)
//    }

}
