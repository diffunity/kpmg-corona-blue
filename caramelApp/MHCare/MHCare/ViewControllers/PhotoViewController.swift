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
    
    
    @IBOutlet weak var barChartView: BarChartView!
        
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    @IBOutlet weak var videoLevelLabel: UILabel!
    
    @IBOutlet weak var videoAverageLabel: UILabel!
    
    @IBOutlet weak var videoOverallOuterView: UIView!
    @IBOutlet weak var videoOverallView: UIView!
    
    
    @IBOutlet weak var videoPieChartOuterView: UIView!
    @IBOutlet weak var videoPieChartTabView: UIView!
    @IBOutlet weak var videoPieChartView: PieChartView!
    
    
    @IBOutlet weak var videoCircleChartView: UIView!
    
    
    @IBOutlet weak var videoCombinedTabOuterView: UIView!
    @IBOutlet weak var videoCombinedTabView: UIView!
    
    @IBOutlet weak var videoBarChartView: BarChartView!
    
    @IBOutlet weak var videoLineChartView: LineChartView!
    
    @IBOutlet weak var photoResultOuterView: UIView!
    @IBOutlet weak var photoResultTabView: UIView!
    
    
    
    @IBOutlet weak var videoResultOuterView: UIView!
    @IBOutlet weak var videoResultTabView: UIView!
    
    
    let lightColor = UIColor(displayP3Red: 198/255, green: 192/255, blue: 255/255, alpha: 1.0)
    let darkColor = UIColor(displayP3Red: 134/255, green: 114/255, blue: 244/255, alpha: 1.0)

    var photoData: PhotoData!
    
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
    let wordcount = [20, 15, 10, 5, 5]
    
    let circlevalues = [0.7]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoButton.alpha = 0.3
        photoButton.alpha = 1.0
        photoScrollView.isHidden = false
        videoScrollView.isHidden = true
        
        
        setLabels()
        setOverallTabUI()
        circleChart(Values: [photoData.photoCircleValue])
        // Do any additional setup after loading the view.
        lineChart(photoData.photoLineChartDays, values: photoData.photoLineChartData)
//        barChart(dataPoints: graphArray, barValues: bardata1)
        setPhotoResultUI()
        
        // Pie Chart
    }
    
    
    @IBAction func photoToggled(_ sender: Any) {
        if photoScrollView.isHidden {
            
            setLabels()
            setOverallTabUI()
            lineChart(photoData.photoLineChartDays, values: photoData.photoLineChartData)
//            barChart(dataPoints: graphArray, barValues: bardata1)
            circleChart(Values: [photoData.photoCircleValue])
            setPhotoResultUI()
            
            videoButton.alpha = 0.3
            photoButton.alpha = 1.0
            videoScrollView.isHidden = true
            photoScrollView.isHidden = false
        }
    }
    
    
    @IBAction func videoToggled(_ sender: Any) {
        if videoScrollView.isHidden {
            
            setVideoLabels()
            setVideoOverallTabUI()
            videoLineChart(photoData.videoLineChartDays, values: photoData.videoLineChartData)
//            videoBarChart(dataPoints: graphArray, barValues: bardata1)
            videoCircleChart(Values: [photoData.videoCircleValue])
            setVideoResultUI()
            
            
            photoButton.alpha = 0.3
            videoButton.alpha = 1.0
            photoScrollView.isHidden = true
            videoScrollView.isHidden = false
        }
    }
    
    func setLabels() {
        averageLabel.text = String(photoData.photoOverall)
        setOverall()
    }
    
    func setOverall() {
        let label = String(photoData.photoOverall) + "%"
        averageLabel.text = label
        if photoData.photoOverall > 50 {
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
        line1.valueFont = UIFont.systemFont(ofSize: 10)
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
    
    func setVideoLabels() {
        videoAverageLabel.text = String(photoData.videoOverall)
        setVideoOverall()
    }
    
    
    func setVideoOverall() {
        let label = String(photoData.videoOverall) + "%"
        videoAverageLabel.text = label
        if photoData.videoOverall > 50 {
            videoLevelLabel.text = "High"
        } else {
            videoLevelLabel.text = "Low"
        }
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


        videoCircleChartView.addSubview(progressRingView)
        

    }
    
    func videoLineChart(_ dataPoints: [String], values: [Double]) {
        setVideoCombinedChartUI()
        videoLineChartView.noDataText = "No data available!"
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
        videoLineChartView.data = data
        videoLineChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        videoLineChartView.xAxis.labelTextColor = UIColor.systemGray4
        
        videoLineChartView.setScaleEnabled(false)
        
        videoLineChartView.animate(xAxisDuration: 1.5)
        videoLineChartView.drawGridBackgroundEnabled = false
        videoLineChartView.leftAxis.drawAxisLineEnabled = false
        videoLineChartView.leftAxis.drawGridLinesEnabled = false
        videoLineChartView.rightAxis.drawAxisLineEnabled = false
        videoLineChartView.rightAxis.drawGridLinesEnabled = false
        videoLineChartView.legend.enabled = false
        videoLineChartView.xAxis.enabled = true
        videoLineChartView.xAxis.labelPosition = .bottom
        videoLineChartView.xAxis.drawGridLinesEnabled = false
        videoLineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        videoLineChartView.leftAxis.enabled = false
        videoLineChartView.rightAxis.enabled = false
        videoLineChartView.rightAxis.drawLabelsEnabled = false
        //lineChartView.xAxis.drawLabelsEnabled = false
        videoLineChartView.drawMarkers = true
        videoLineChartView.marker = ChartMarker()
        videoLineChartView.highlightPerDragEnabled = true
        videoLineChartView.animate(xAxisDuration: 1.5, yAxisDuration: 2.0, easingOption: .easeInBounce)
        videoLineChartView.setExtraOffsets(left: 15.0, top: -10.0, right: 15.0, bottom: 15.0)
        
        
        
    }
    
    
    

    
    func setPhotoResultUI() {
        photoResultOuterView.clipsToBounds = false
        photoResultOuterView.layer.shadowColor = UIColor.black.cgColor
        photoResultOuterView.layer.shadowOpacity = 0.1
        photoResultOuterView.layer.shadowOffset = CGSize(width: 0, height: 10)
        photoResultOuterView.layer.shadowRadius = 15
        
        photoResultTabView.clipsToBounds = true
        photoResultTabView.layer.cornerRadius = 15
        
        photoResultOuterView.addSubview(photoResultTabView)
    }
    
    
    func setVideoResultUI() {
        videoResultOuterView.clipsToBounds = false
        videoResultOuterView.layer.shadowColor = UIColor.black.cgColor
        videoResultOuterView.layer.shadowOpacity = 0.1
        videoResultOuterView.layer.shadowOffset = CGSize(width: 0, height: 10)
        videoResultOuterView.layer.shadowRadius = 15
        
        videoResultTabView.clipsToBounds = true
        videoResultTabView.layer.cornerRadius = 15
        
        videoResultOuterView.addSubview(videoResultTabView)
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
