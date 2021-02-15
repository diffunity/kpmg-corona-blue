//
//  PhotoViewController.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/06.
//

import UIKit
import Charts

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
    
    @IBOutlet weak var combinedTabOuterView: UIView!
    @IBOutlet weak var combinedTabView: UIView!
    @IBOutlet weak var combinedChartView: CombinedChartView!
    
    
    @IBOutlet weak var videoOverallOuterView: UIView!
    @IBOutlet weak var videoOverallView: UIView!
    
    
    @IBOutlet weak var videoPieChartOuterView: UIView!
    @IBOutlet weak var videoPieChartTabView: UIView!
    @IBOutlet weak var videoPieChartView: PieChartView!
    
    @IBOutlet weak var videoCombinedTabOuterView: UIView!
    @IBOutlet weak var videoCombinedTabView: UIView!
    @IBOutlet weak var videoCombinedChartView: CombinedChartView!
    
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoButton.alpha = 0.3
        photoButton.alpha = 1.0
        photoScrollView.isHidden = false
        videoScrollView.isHidden = true
        
        
        
        setOverallTabUI()

        // Do any additional setup after loading the view.
        combinedChart(dataPoints: graphArray, barValues: bardata1, barValues2: bardata2, lineValues: linedata)
        // Pie Chart
        pieChart(dataPoints: emotions, values: unitsSold)
    }
    
    
    @IBAction func photoToggled(_ sender: Any) {
        if photoScrollView.isHidden {
            
            setOverallTabUI()
            pieChart(dataPoints: emotions, values: unitsSold)
            combinedChart(dataPoints: graphArray, barValues: bardata1, barValues2: bardata2, lineValues: linedata)
            
            
            videoButton.alpha = 0.3
            photoButton.alpha = 1.0
            videoScrollView.isHidden = true
            photoScrollView.isHidden = false
        }
    }
    
    
    @IBAction func videoToggled(_ sender: Any) {
        if videoScrollView.isHidden {
            
            setVideoOverallTabUI()
            videoPieChart(dataPoints: emotions, values: unitsSold)
            videoCombinedChart(dataPoints: graphArray, barValues: bardata1, barValues2: bardata2, lineValues: linedata)
            
            
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
        let colors: [UIColor] = [lightColor, darkColor]
        
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
    
    
    func combinedChart(dataPoints: [String], barValues: [Double],barValues2: [Double], lineValues: [Double]) {
        setCombinedChartUI()
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
    
    
    func videoPieChart(dataPoints: [String], values: [Double]) {
        videoPieChartView.noDataText = "You need to provide data for the chart."
        
        setVideoPieChartUI()
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry1 = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i])
            dataEntries.append(dataEntry1)
        }
      
        let pieChartDataSet = PieChartDataSet(entries: dataEntries)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        videoPieChartView.data = pieChartData
        videoPieChartView.centerText = ""
    
        // 랜덤 컬러 지정
        let colors: [UIColor] = [lightColor, darkColor]
        
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
        videoPieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        videoPieChartView.legend.enabled = false

    }
    
    
    func videoCombinedChart(dataPoints: [String], barValues: [Double],barValues2: [Double], lineValues: [Double]) {
        setVideoCombinedChartUI()
        videoCombinedChartView.noDataText = "You need to provide data for the chart."
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
        videoCombinedChartView.data = data
        
        
        // 여기서부터는 그래프 예쁘게 수정하는 내용
        // 전체
        // X축 데이터 설정
        videoCombinedChartView.xAxis.axisMaximum = data.xMax + 0.25
        videoCombinedChartView.xAxis.axisMinimum = data.xMin - 0.25
        
        // X축 레이블 포맷 ( index -> 실제데이터 )
        videoCombinedChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: graphArray)
        
        // 배경 그리드 라인 그릴지 여부
        videoCombinedChartView.xAxis.drawGridLinesEnabled = false
        videoCombinedChartView.leftAxis.drawGridLinesEnabled = false
        videoCombinedChartView.backgroundColor = .white
        // 리미트 라인 생성 (평균 라인)
        //videoCombinedChartView.leftAxis.addLimitLine(ChartLimitLine(limit: 10, label: "평균"))
        
        // 우측 레이블 제거
        videoCombinedChartView.rightAxis.enabled = false
        
        // X축 레이블 위치 조정
        videoCombinedChartView.xAxis.labelPosition = .bottom
        videoCombinedChartView.leftAxis.axisMinimum = 0
        videoCombinedChartView.rightAxis.axisMinimum = 0
        
        // legend
        let l = videoCombinedChartView.legend
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
        
        videoCombinedChartView.doubleTapToZoomEnabled = false

        // 애니메이션 효과
        // 기본 애니메이션
        videoCombinedChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        // 옵션 애니메이션
        //videoCombinedChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
    }
}
