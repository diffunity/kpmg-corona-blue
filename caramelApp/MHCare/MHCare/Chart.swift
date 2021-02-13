//
//  Chart.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/14.
//
import Charts

class DataSetValueFormatter: IValueFormatter {
    
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        ""
    }
}

class XAxisFormatter: IAxisValueFormatter {
    
    let titles = ["Happy", "Sadness", "Surprise", "Fear", "Anger", "Disgust", "Neutral" ]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        titles[Int(value) % titles.count]
    }
}

class YAxisFormatter: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        "\(Int(value)) $"
    }
}
