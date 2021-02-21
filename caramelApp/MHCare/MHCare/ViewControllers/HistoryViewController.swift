//
//  HistoryViewController.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/07.
//

import UIKit
import Charts

class HistoryViewController: UIViewController {

    
    @IBOutlet weak var monthButton: UIButton!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    var graphArray: [String] = ["Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    let bardata1 = [90.0, 60.0, 16.0, 78.0, 34.0, 36.0, 62.0]

    
    let lightColor = UIColor.clear
    let darkColor = UIColor.white
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        monthButton.alpha = 0.3
        lineChart(graphArray, values: bardata1)

        // Do any additional setup after loading the view.
    }
    
    func setNavigationBar() {
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }

    
    func lineChart(_ dataPoints: [String], values: [Double]) {
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
        lineChartView.xAxis.labelTextColor = UIColor.white
        
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
    
    
    private func getGradientFilling() -> CGGradient {
        // Setting fill gradient color
        let coloTop = darkColor.cgColor
        let colorBottom = darkColor.cgColor
        // Colors of the gradient
        let gradientColors = [coloTop, colorBottom] as CFArray
        // Positioning of the gradient
        let colorLocations: [CGFloat] = [0.3, 0.0]
        // Gradient Object
        return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!

    }
    
}
