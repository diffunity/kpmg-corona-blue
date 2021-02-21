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
    
    
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var averageLabel: UILabel!
    
    @IBOutlet weak var overallOuterView: UIView!
    @IBOutlet weak var overallView: UIView!
    
    @IBOutlet weak var pieChartOuterView: UIView!
    @IBOutlet weak var pieChartTabView: UIView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    
    @IBOutlet weak var circleChartView: UIView!
    
    
    @IBOutlet weak var combinedTabOuterView: UIView!
    @IBOutlet weak var combinedTabView: UIView!
    
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var horizontalBarChartOuterView: UIView!
    @IBOutlet weak var horizontalBarChartTabView: UIView!
    @IBOutlet weak var horizontalBarChartView: HorizontalBarChartView!
    
    @IBOutlet weak var radarChartOuterView: UIView!
    @IBOutlet weak var radarChartTabView: UIView!
    
    @IBOutlet weak var barChartView: BarChartView!
    
    
    
    @IBOutlet weak var toneLevelLabel: UILabel!
    
    @IBOutlet weak var toneAverageLabel: UILabel!
    
    @IBOutlet weak var toneOverallOuterView: UIView!
    @IBOutlet weak var toneOverallTabView: UIView!
    
    @IBOutlet weak var tonePieChartOuterView: UIView!
    @IBOutlet weak var tonePieChartTabView: UIView!
    @IBOutlet weak var tonePieChartView: PieChartView!
    
    
    @IBOutlet weak var toneCircleChartView: UIView!
    
    
    @IBOutlet weak var toneCombinedChartOuterView: UIView!
    @IBOutlet weak var toneCombinedChartTabView: UIView!

    
    @IBOutlet weak var toneLineChartView: LineChartView!
    
    @IBOutlet weak var toneBarChartView: BarChartView!
    
    
    var voiceData: VoiceData!
    
    let lightColor = UIColor(displayP3Red: 131/255, green: 182/255, blue: 255/255, alpha: 1.0)
    let darkColor = UIColor(displayP3Red: 66/255, green: 56/255, blue: 242/255, alpha: 1.0)

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toneButton.alpha = 0.3
        contentButton.alpha = 1.0
        contentScrollView.isHidden = false
        toneScrollView.isHidden = true
        
        setOverallTabUI()
        setOverall()
        
        setHorizontalBarChartUI()

        // Do any additional setup after loading the view.
        circleChart(Values: [voiceData.contentCircleValue])
        lineChart(voiceData.contentLineChartDays, values: voiceData.contentLineChartData)
        barChart(dataPoints: voiceData.contentEmotions, barValues: voiceData.contentEmotionData)


    }
    
    
    @IBAction func toneToggled(_ sender: Any) {
        if toneScrollView.isHidden {
            
            setToneOverallTabUI()
            setToneOverall()
            toneLineChart(voiceData.toneLineChartDays, values: voiceData.toneLineChartData)
            toneCircleChart(Values: [voiceData.toneCircleValue])
            
            
            contentButton.alpha = 0.3
            toneButton.alpha = 1.0
            contentScrollView.isHidden = true
            toneScrollView.isHidden = false
        }
    }
    
    @IBAction func contentToggled(_ sender: Any) {
        if contentScrollView.isHidden {
            
            setOverallTabUI()
            setOverall()

            // Do any additional setup after loading the view.
            circleChart(Values: [voiceData.contentCircleValue])
            lineChart(voiceData.contentLineChartDays, values: voiceData.contentLineChartData)
            barChart(dataPoints: voiceData.contentEmotions, barValues: voiceData.contentEmotionData)

            toneButton.alpha = 0.3
            contentButton.alpha = 1.0
            toneScrollView.isHidden = true
            contentScrollView.isHidden = false
        }
    }
    
    
    func setOverall() {
        let label = String(voiceData.contentOverall) + "%"
        averageLabel.text = label
        if voiceData.contentOverall > 50 {
            levelLabel.text = "High"
        } else {
            levelLabel.text = "Low"
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
        lineChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 15)
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
    

    func setToneOverall() {
        let label = String(voiceData.toneOverall) + "%"
        toneAverageLabel.text = label
        if voiceData.toneOverall > 50 {
            toneLevelLabel.text = "High"
        } else {
            toneLevelLabel.text = "Low"
        }
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
    
    
//    func toneBarChart(dataPoints: [String], barValues: [Double]) {
//        setToneCombinedChartUI()
//        toneBarChartView.noDataText = "You need to provide data for the chart."
//        // bar, line 엔트리 생성
//        var barDataEntries: [BarChartDataEntry] = []
//
//        // bar, line 엔트리 삽입
//        for i in 0..<dataPoints.count {
//            let barDataEntry = BarChartDataEntry(x: Double(i), y: barValues[i])
//            barDataEntries.append(barDataEntry)
//
//        }
//
//        // 데이터셋 생성
//        let barChartDataSet = BarChartDataSet(entries: barDataEntries, label: "일일 우울지수")
//
//
//        // bar 데이터 지정
//        let data = BarChartData(dataSet: barChartDataSet)
//
//        // combined 데이터 지정
//        toneBarChartView.data = data
////        let font2 =  UIFont.init(name: "Open Sans", size: 10.0)!
////        barChartView.data!.setValueFont(font2)
//        toneBarChartView.data!.setValueTextColor(UIColor.systemGray2)
//        let pFormatter = NumberFormatter()
//        pFormatter.numberStyle = .percent
//        pFormatter.maximumFractionDigits = 1
//        pFormatter.multiplier = 1
//        pFormatter.percentSymbol = " %"
//
//        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
//
//
//        // 여기서부터는 그래프 예쁘게 수정하는 내용
//        // 전체
//        // X축 데이터 설정
//        toneBarChartView.xAxis.axisMaximum = data.xMax + 0.25
//        toneBarChartView.xAxis.axisMinimum = data.xMin - 0.25
//        toneBarChartView.xAxis.drawAxisLineEnabled = false
//
//        // X축 레이블 포맷 ( index -> 실제데이터 )
//        toneBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
////        let font =  UIFont.init(name: "Open Sans", size: 13.0)!
////        barChartView.xAxis.labelFont = font
//
//        // 배경 그리드 라인 그릴지 여부
//        toneBarChartView.xAxis.drawGridLinesEnabled = false
//
//        toneBarChartView.leftAxis.drawGridLinesEnabled = false
//        toneBarChartView.backgroundColor = .white
//        toneBarChartView.drawBarShadowEnabled = false
//
//        // 우측 레이블 제거
//        toneBarChartView.rightAxis.enabled = false
//        toneBarChartView.leftAxis.enabled = false
//
//
//        // X축 레이블 위치 조정
//        toneBarChartView.xAxis.labelPosition = .bottom
//        toneBarChartView.xAxis.labelTextColor = UIColor.systemGray
//        toneBarChartView.leftAxis.axisMinimum = 0
//        toneBarChartView.rightAxis.axisMinimum = 0
//
//
//        // legend
//        toneBarChartView.legend.enabled = false
//
//
//        // bar chart
//        // 바 컬러, 바 두께
//
//        barChartDataSet.colors = [lightColor, lightColor, lightColor, lightColor, lightColor, lightColor,darkColor ]
//
//        let barWidth = 0.5
//        data.barWidth = barWidth
//        barChartDataSet.barShadowColor = UIColor.systemGray6
//        barChartDataSet.highlightEnabled = false
//        barChartDataSet.axisDependency = .left
//        // 줌 안되게
//
//        toneBarChartView.doubleTapToZoomEnabled = false
//
//        // 애니메이션 효과
//        // 기본 애니메이션
//        //combinedChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
//
//        // 옵션 애니메이션
//        toneBarChartView.animate(yAxisDuration: 2.0, easingOption: .easeInBounce)
//        toneBarChartView.drawMarkers = true
//        toneBarChartView.marker = ChartMarker()
//        toneBarChartView.setExtraOffsets(left: 30.0, top: 0.0, right: 30.0, bottom: 15.0)
//    }
    
    func toneLineChart(_ dataPoints: [String], values: [Double]) {
        setToneCombinedChartUI()
        toneLineChartView.noDataText = "No data available!"
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
        toneLineChartView.data = data
        toneLineChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 15)
        toneLineChartView.xAxis.labelTextColor = UIColor.systemGray4
        
        toneLineChartView.setScaleEnabled(false)
        
        toneLineChartView.animate(xAxisDuration: 1.5)
        toneLineChartView.drawGridBackgroundEnabled = false
        toneLineChartView.leftAxis.drawAxisLineEnabled = false
        toneLineChartView.leftAxis.drawGridLinesEnabled = false
        toneLineChartView.rightAxis.drawAxisLineEnabled = false
        toneLineChartView.rightAxis.drawGridLinesEnabled = false
        toneLineChartView.legend.enabled = false
        toneLineChartView.xAxis.enabled = true
        toneLineChartView.xAxis.labelPosition = .bottom
        toneLineChartView.xAxis.drawGridLinesEnabled = false
        toneLineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        toneLineChartView.leftAxis.enabled = false
        toneLineChartView.rightAxis.enabled = false
        toneLineChartView.rightAxis.drawLabelsEnabled = false
        //lineChartView.xAxis.drawLabelsEnabled = false
        toneLineChartView.drawMarkers = true
        toneLineChartView.marker = ChartMarker()
        toneLineChartView.highlightPerDragEnabled = true
        toneLineChartView.animate(xAxisDuration: 1.5, yAxisDuration: 2.0, easingOption: .easeInBounce)
        toneLineChartView.setExtraOffsets(left: 15.0, top: -10.0, right: 15.0, bottom: 15.0)
        
        
        
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
