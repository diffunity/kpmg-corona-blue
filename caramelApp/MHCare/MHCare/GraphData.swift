//
//  GraphData.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/21.
//

import UIKit

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
        let avg = Int(Double(total) / Double(lineChartDays.count))
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
        let contentAvg = Int(Double(contentTotal) / Double(contentLineChartDays.count))
        self.contentOverall = contentAvg
        self.contentCircleValue = Double(contentAvg) / 100
        
        self.toneLineChartDays = toneLineChartDays
        self.toneLineChartData = toneLineChartData
        let toneTotal = toneLineChartData.reduce(0, +)
        let toneAvg = Int(Double(toneTotal) / Double(toneLineChartDays.count))
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
    
    let photoFacialUrls: [String]
    let photoFacialResults: [FacialResult]
    let photoNonFacialUrls: [String]
    let photoNonFacialResults: [NonFacialResult]
    let videoResults: [[Double]]

    
//    var photoFacialImages: [UIImage] {
//        return getImagesFromUrl(urls: self.photoFacialUrls)
//    }
//
//    var photoNonFacialImages: [UIImage] {
//        return getImagesFromUrl(urls: self.photoNonFacialUrls)
//    }
    
    var photoFacialImages: [UIImage] = []
    var photoNonFacialImages: [UIImage] = []
    
    let videoImages: [UIImage]
    
    
    
    
    init(photoLineChartDays:[String], photoLineChartData:[Double], videoLineChartDays:[String], videoLineChartData:[Double], photoFacialUrls:[String], photoFacialResults:[FacialResult], photoNonFacialUrls:[String], photoNonFacialResults:[NonFacialResult], videoImages:[UIImage], videoResults: [[Double]]) {
        self.photoLineChartDays = photoLineChartDays
        self.photoLineChartData = photoLineChartData
        let photoTotal = photoLineChartData.reduce(0, +)
        let photoAvg = Int(Double(photoTotal) / Double(photoLineChartDays.count))
        self.photoOverall = photoAvg
        self.photoCircleValue = Double(photoAvg) / 100
        
        self.videoLineChartDays = videoLineChartDays
        self.videoLineChartData = videoLineChartData
        let videoTotal = videoLineChartData.reduce(0, +)
        let videoAvg = Int(Double(videoTotal) / Double(videoLineChartDays.count))
        self.videoOverall = videoAvg
        self.videoCircleValue = Double(videoAvg) / 100
        
        self.photoFacialUrls = photoFacialUrls
        self.photoFacialResults = photoFacialResults
        self.photoNonFacialUrls = photoNonFacialUrls
        self.photoNonFacialResults = photoNonFacialResults
        self.videoImages = videoImages
        self.videoResults = videoResults
        
        pushImages()
        

        
    }
    
    func pushImages() {
        print("pushing")
        var facialImages:[UIImage] = []
        
        for u in self.photoFacialUrls {
            let url = URL(string: u)
            let data = try! Data(contentsOf: url!)
            facialImages.append(UIImage(data: data)!)
        }
        self.photoFacialImages = facialImages
        
        var nonFacialImages:[UIImage] = []
        
        for u in self.photoNonFacialUrls {
            let url = URL(string: u)
            let data = try! Data(contentsOf: url!)
            nonFacialImages.append(UIImage(data: data)!)
        }
        self.photoNonFacialImages = nonFacialImages
        
        
    }
    
    func getImagesFromUrl(urls: [String]) -> [UIImage] {
        var images:[UIImage] = []
        
        for u in urls {
            let url = URL(string: u)
            let data = try! Data(contentsOf: url!)
            images.append(UIImage(data: data)!)
        }
        
        return images
    }
    
}

