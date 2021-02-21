//
//  GraphData.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/21.
//

class GraphData {
    static let shared = GraphData()
    var textData: TextData!
    var voiceData: VoiceData!
    var photoData: PhotoData!
}

class TextData {
    let lineChartDays:[String]
    let lineChartData:[Double]
    
    let emotions:[String]
    let emotionData:[Double]
    let circleValue: Double
    
    var overall: Int
    
    init(lineChartDays:[String], lineChartData:[Double], emotions:[String], emotionData:[Double]) {
        self.lineChartDays = lineChartDays
        self.lineChartData = lineChartData
        self.emotions = emotions
        self.emotionData = emotionData
        let total = lineChartData.reduce(0, +)
        let avg = Int(total / Double(lineChartDays.count))
        self.overall = avg
        self.circleValue = Double(avg) / 100
        
    }
}


class VoiceData {
    let contentLineChartDays:[String]
    let contentLineChartData:[Double]
    
    let contentEmotions:[String]
    let contentEmotionData:[Double]
    let contentCircleValue: Double
    var contentOverall:Int
    
    let toneLineChartDays:[String]
    let toneLineChartData:[Double]
    let toneCircleValue: Double
    var toneOverall:Int
    
    init(contentLineChartDays:[String], contentLineChartData:[Double], contentEmotions:[String], contentEmotionData:[Double], toneLineChartDays:[String], toneLineChartData:[Double]) {
        self.contentLineChartDays = contentLineChartDays
        self.contentLineChartData = contentLineChartData
        self.contentEmotions = contentEmotions
        self.contentEmotionData = contentEmotionData
        let contentTotal = contentLineChartData.reduce(0, +)
        let contentAvg = Int(contentTotal / Double(contentLineChartDays.count))
        self.contentOverall = contentAvg
        self.contentCircleValue = Double(contentAvg) / 100
        
        self.toneLineChartDays = toneLineChartDays
        self.toneLineChartData = toneLineChartData
        let toneTotal = toneLineChartData.reduce(0, +)
        let toneAvg = Int(toneTotal / Double(toneLineChartDays.count))
        self.toneOverall = toneAvg
        self.toneCircleValue = Double(toneAvg) / 100
        
        
        
    }
    
}

class PhotoData {
    let photoLineChartDays:[String]
    let photoLineChartData:[Double]
    let photoOverall: Int
    let photoCircleValue: Double
    
    let videoLineChartDays:[String]
    let videoLineChartData:[Double]
    let videoOverall: Int
    let videoCircleValue: Double
    
    
    init(photoLineChartDays:[String], photoLineChartData:[Double], videoLineChartDays:[String], videoLineChartData:[Double]) {
        self.photoLineChartDays = photoLineChartDays
        self.photoLineChartData = photoLineChartData
        let photoTotal = photoLineChartData.reduce(0, +)
        let photoAvg = Int(photoTotal / Double(photoLineChartDays.count))
        self.photoOverall = photoAvg
        self.photoCircleValue = Double(photoAvg) / 100
        
        self.videoLineChartDays = videoLineChartDays
        self.videoLineChartData = videoLineChartData
        let videoTotal = videoLineChartData.reduce(0, +)
        let videoAvg = Int(videoTotal / Double(videoLineChartDays.count))
        self.videoOverall = videoAvg
        self.videoCircleValue = Double(videoAvg) / 100
        
        
        
    }
}
