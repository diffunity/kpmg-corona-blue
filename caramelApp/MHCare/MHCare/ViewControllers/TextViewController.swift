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

    
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var averageLabel: UILabel!
    
    @IBOutlet weak var overallOuterView: UIView!
    @IBOutlet weak var overallView: UIView!
    
    @IBOutlet weak var combinedTabOuterView: UIView!
    @IBOutlet weak var combinedTabView: UIView!

    

    @IBOutlet weak var lineChartView: LineChartView!
    
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var pieChartOuterView: UIView!
    @IBOutlet weak var pieChartTabView: UIView!
    

    @IBOutlet weak var horizontalBarChartView: HorizontalBarChartView!
    @IBOutlet weak var horizontalBarChartTabView: UIView!
    @IBOutlet weak var horizontalBarChartOuterView: UIView!
    
    
    @IBOutlet weak var radarChartOuterView: UIView!
    @IBOutlet weak var radarChartTabView: UIView!
    @IBOutlet weak var radarChartView: RadarChartView!
    
    @IBOutlet weak var barChartView: BarChartView!

    @IBOutlet weak var circleChartView: UIView!
    
    var textData: TextData!
    
    
    let lightColor = UIColor(displayP3Red: 255/255, green: 196/255, blue: 211/255, alpha: 1.0)
    let darkColor = UIColor(displayP3Red: 235/255, green: 81/255, blue: 190/255, alpha: 1.0)

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLabels()
        setOverallTabUI()


        lineChart(textData.lineChartDays, values: textData.lineChartData)
        barChart(dataPoints: textData.emotions, barValues: textData.emotionData)



        circleChart(Values: [textData.circleValue])


        setHorizontalBarChartUI()
        

    }
    
    func setLabels() {
        averageLabel.text = String(textData.overall)
        setOverall()
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
    
    
    func setOverall() {
        let label = String(textData.overall) + "%"
        averageLabel.text = label
        if textData.overall > 50 {
            levelLabel.text = "High"
        } else {
            levelLabel.text = "Low"
        }
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


        circleChartView.addSubview(progressRingView)
        
    }
    
    
    func lineChart(_ dataPoints: [String], values: [Double]) {
        setCombinedChartUI()
        lineChartView.noDataText = "No data available!"
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<values.count {
//            print("chart point : \(values[i])")
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let line1 = LineChartDataSet(entries: dataEntries, label: "Units Consumed")
        line1.colors = [darkColor]
        line1.mode = .cubicBezier
        line1.cubicIntensity = 0.2
        //line1.drawCirclesEnabled = false
        //line1.drawCircleHoleEnabled = false
        line1.circleColors = [lightColor]
        line1.circleHoleColor = darkColor
        line1.circleHoleRadius = 2.5
        line1.circleRadius = 3.5
        let gradient = getGradientFilling()
        line1.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        line1.drawFilledEnabled = true
        let bcolor = NSUIColor.clear
        let tcolor = darkColor
        line1.valueFont = UIFont.systemFont(ofSize: 15)
        line1.valueColors = [bcolor, bcolor, bcolor, bcolor, bcolor, bcolor, tcolor]
        line1.highlightLineDashLengths = [3.0]
        line1.highlightLineWidth = 0.7
        line1.drawHorizontalHighlightIndicatorEnabled = false
        line1.highlightColor = UIColor.systemGray4
        
        let data = LineChartData()
        data.addDataSet(line1)
        lineChartView.data = data
        lineChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        lineChartView.xAxis.labelTextColor = UIColor.systemGray4
        
        lineChartView.setScaleEnabled(false)
        
        lineChartView.animate(xAxisDuration: 1.5)
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.legend.enabled = false
        lineChartView.xAxis.enabled = true
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        //lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.drawMarkers = true
        lineChartView.marker = ChartMarker()
        lineChartView.highlightPerDragEnabled = true
        lineChartView.animate(xAxisDuration: 1.5, yAxisDuration: 2.0, easingOption: .easeInBounce)
        lineChartView.setExtraOffsets(left: 15.0, top: -10.0, right: 15.0, bottom: 15.0)
        
        
        
    }
    
    
    
    
    func barChart(dataPoints: [String], barValues: [Double]) {
        setRadarChartUI()
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
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
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

        barChartDataSet.colors = [UIColor(red: 1, green: 0.7686, blue: 0.8941, alpha: 1.0), UIColor(red: 1, green: 0.8824, blue: 0.749, alpha: 1.0), UIColor(red: 1, green: 0.9922, blue: 0.7686, alpha: 1.0), UIColor(red: 0.7686, green: 1, blue: 0.9255, alpha: 1.0), UIColor(red: 0.7686, green: 0.9843, blue: 1, alpha: 1.0), UIColor(red: 0.7686, green: 0.8039, blue: 1, alpha: 1.0), UIColor(red: 0.8196, green: 0.7686, blue: 1, alpha: 1.0) ]

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
        barChartView.setExtraOffsets(left: 15.0, top: 0.0, right: 15.0, bottom: 15.0)
    }

    
    
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
    

    
    private func getGradientFilling() -> CGGradient {
        // Setting fill gradient color
        let coloTop = lightColor.cgColor
        let colorBottom = NSUIColor.white.cgColor
        // Colors of the gradient
        let gradientColors = [coloTop, colorBottom] as CFArray
        // Positioning of the gradient
        let colorLocations: [CGFloat] = [0.3, 0.0]
        // Gradient Object
        return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!

    }
    
}
