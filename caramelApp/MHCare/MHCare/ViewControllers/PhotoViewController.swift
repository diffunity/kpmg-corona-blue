//
//  PhotoViewController.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/06.
//

import UIKit
import Charts
import ConcentricProgressRingView

class PhotoViewController: UIViewController {

    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    
    
    
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var videoScrollView: UIScrollView!
    
    
    @IBOutlet weak var overallOuterView: UIView!
    @IBOutlet weak var overallView: UIView!
    
    @IBOutlet weak var pieChartOuterView: UIView!
    @IBOutlet weak var pieChartTabView: UIView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    
    
    @IBOutlet weak var circleChartView: UIView!
    
    
    @IBOutlet weak var combinedTabOuterView: UIView!
    @IBOutlet weak var combinedTabView: UIView!
    
    
    @IBOutlet weak var barChartView: BarChartView!
        
    
    @IBOutlet weak var videoOverallOuterView: UIView!
    @IBOutlet weak var videoOverallView: UIView!
    
    
    @IBOutlet weak var videoPieChartOuterView: UIView!
    @IBOutlet weak var videoPieChartTabView: UIView!
    @IBOutlet weak var videoPieChartView: PieChartView!
    
    
    @IBOutlet weak var videoCircleChartView: UIView!
    
    
    @IBOutlet weak var videoCombinedTabOuterView: UIView!
    @IBOutlet weak var videoCombinedTabView: UIView!
    
    @IBOutlet weak var videoBarChartView: BarChartView!
    
    
    let lightColor = UIColor(displayP3Red: 198/255, green: 192/255, blue: 255/255, alpha: 1.0)
    let darkColor = UIColor(displayP3Red: 134/255, green: 114/255, blue: 244/255, alpha: 1.0)

    
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
    
    let circlevalues = [0.7]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoButton.alpha = 0.3
        photoButton.alpha = 1.0
        photoScrollView.isHidden = false
        videoScrollView.isHidden = true
        
        
        
        setOverallTabUI()
        circleChart(Values: circlevalues)
        // Do any additional setup after loading the view.
        barChart(dataPoints: graphArray, barValues: bardata1)

        // Pie Chart
    }
    
    
    @IBAction func photoToggled(_ sender: Any) {
        if photoScrollView.isHidden {
            
            setOverallTabUI()
            barChart(dataPoints: graphArray, barValues: bardata1)
            circleChart(Values: circlevalues)
            
            videoButton.alpha = 0.3
            photoButton.alpha = 1.0
            videoScrollView.isHidden = true
            photoScrollView.isHidden = false
        }
    }
    
    
    @IBAction func videoToggled(_ sender: Any) {
        if videoScrollView.isHidden {
            
            setVideoOverallTabUI()
            videoBarChart(dataPoints: graphArray, barValues: bardata1)
            videoCircleChart(Values: circlevalues)
            
            
            photoButton.alpha = 0.3
            videoButton.alpha = 1.0
            photoScrollView.isHidden = true
            videoScrollView.isHidden = false
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

    
    func setVideoOverallTabUI() {
        videoOverallOuterView.clipsToBounds = false
        videoOverallOuterView.layer.shadowColor = UIColor.black.cgColor
        videoOverallOuterView.layer.shadowOpacity = 0.1
        videoOverallOuterView.layer.shadowOffset = CGSize(width: 0, height: 10)
        videoOverallOuterView.layer.shadowRadius = 15
        
        videoOverallView.clipsToBounds = true
        videoOverallView.layer.cornerRadius = 15
        
        videoOverallOuterView.addSubview(videoOverallView)
    }
    
    
    func setVideoPieChartUI() {
        videoPieChartOuterView.clipsToBounds = false
        videoPieChartOuterView.layer.shadowColor = UIColor.black.cgColor
        videoPieChartOuterView.layer.shadowOpacity = 0.1
        videoPieChartOuterView.layer.shadowOffset = CGSize(width: 0, height: 10)
        videoPieChartOuterView.layer.shadowRadius = 15
        
        videoPieChartTabView.clipsToBounds = true
        videoPieChartTabView.layer.cornerRadius = 15
        
        videoPieChartOuterView.addSubview(videoPieChartTabView)
        
    }
    
    func setVideoCombinedChartUI() {
        videoCombinedTabOuterView.clipsToBounds = false
        videoCombinedTabOuterView.layer.shadowColor = UIColor.black.cgColor
        videoCombinedTabOuterView.layer.shadowOpacity = 0.1
        videoCombinedTabOuterView.layer.shadowOffset = CGSize(width: 0, height: 10)
        videoCombinedTabOuterView.layer.shadowRadius = 15
        
        videoCombinedTabView.clipsToBounds = true
        videoCombinedTabView.layer.cornerRadius = 15
        
        videoCombinedTabOuterView.addSubview(videoCombinedTabView)
    }
    

    
    
    func videoCircleChart(Values: [Double]){
        setVideoPieChartUI()
        let fgColor1 = darkColor
        let bgColor1 = UIColor.systemGray5
        let rings = [
            ProgressRing(color: fgColor1, backgroundColor: bgColor1, width: 15),
            //ProgressRing(color: fgColor2, backgroundColor: bgColor2, width: 20),
            //ProgressRing(color: fgColor3, backgroundColor: bgColor2, width: 20),
        ]
        let margin: CGFloat = 2
        let radius: CGFloat = 70
        let progressRingView = ConcentricProgressRingView(center: videoCircleChartView.center, radius: radius, margin: margin, rings: rings)
        progressRingView.arcs[0].setProgress(CGFloat(Values[0]), duration: 2)
        //progressRingView.arcs[1].setProgress(0.8, duration: 2)
        //progressRingView.arcs[2].setProgress(0.4, duration: 2)

        videoCircleChartView.addSubview(progressRingView)
        
//        let horizontalConstraint = NSLayoutConstraint(item: progressRingView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: circleChartView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
//        let verticalConstraint = NSLayoutConstraint(item: progressRingView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: circleChartView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
//        circleChartView.addConstraints([horizontalConstraint, verticalConstraint])
    }
    
    func videoBarChart(dataPoints: [String], barValues: [Double]) {
        setVideoCombinedChartUI()
        videoBarChartView.noDataText = "You need to provide data for the chart."
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
        videoBarChartView.data = data
//        let font2 =  UIFont.init(name: "Open Sans", size: 10.0)!
//        barChartView.data!.setValueFont(font2)
        videoBarChartView.data!.setValueTextColor(UIColor.systemGray2)
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))

        
        // 여기서부터는 그래프 예쁘게 수정하는 내용
        // 전체
        // X축 데이터 설정
        videoBarChartView.xAxis.axisMaximum = data.xMax + 0.25
        videoBarChartView.xAxis.axisMinimum = data.xMin - 0.25
        videoBarChartView.xAxis.drawAxisLineEnabled = false

        // X축 레이블 포맷 ( index -> 실제데이터 )
        videoBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: graphArray)
//        let font =  UIFont.init(name: "Open Sans", size: 13.0)!
//        barChartView.xAxis.labelFont = font

        // 배경 그리드 라인 그릴지 여부
        videoBarChartView.xAxis.drawGridLinesEnabled = false
   
        videoBarChartView.leftAxis.drawGridLinesEnabled = false
        videoBarChartView.backgroundColor = .white
        videoBarChartView.drawBarShadowEnabled = false

        // 우측 레이블 제거
        videoBarChartView.rightAxis.enabled = false
        videoBarChartView.leftAxis.enabled = false
        
        
        // X축 레이블 위치 조정
        videoBarChartView.xAxis.labelPosition = .bottom
        videoBarChartView.xAxis.labelTextColor = UIColor.systemGray
        videoBarChartView.leftAxis.axisMinimum = 0
        videoBarChartView.rightAxis.axisMinimum = 0
        
        
        // legend
        videoBarChartView.legend.enabled = false

        
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
        
        videoBarChartView.doubleTapToZoomEnabled = false

        // 애니메이션 효과
        // 기본 애니메이션
        //combinedChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        // 옵션 애니메이션
        videoBarChartView.animate(yAxisDuration: 2.0, easingOption: .easeInBounce)
        videoBarChartView.drawMarkers = true
        videoBarChartView.marker = ChartMarker()
        videoBarChartView.setExtraOffsets(left: 30.0, top: 0.0, right: 30.0, bottom: 15.0)
    }

}
