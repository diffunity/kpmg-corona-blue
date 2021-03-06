//
//  HomeViewController.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/05.
//

import UIKit
import ConcentricProgressRingView

let updateUrl = "http://ec2co-ecsel-f2k8u3ar7ixb-1602496836.ap-northeast-2.elb.amazonaws.com:8000/update/emotion-result/text"

class HomeViewController: UIViewController {
    
    let photoManager = PhotoManager()
    
    var facialResults:[[Double]] = [[10.0, 53.6, 14.8],[10.0, 53.6, 14.8],
                                    [10.0, 53.6, 14.8],[10.0, 53.6, 14.8],
                                    [10.0, 53.6, 14.8],[10.0, 53.6, 14.8],
                                    [10.0, 53.6, 14.8]]
    
    
    
    @IBOutlet weak var overallLabel: UILabel!
    
    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var outerOverviewView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileBGView: UIVisualEffectView!
    
    
    @IBOutlet weak var overallCircleView: UIView!
    @IBOutlet weak var detailCircleView: UIView!
    
    
    var graphArray: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let bardata1 = [90.0, 60.0, 16.0, 78.0, 34.0, 53.0, 33.0]

    // Radar Chart
    let subjects = ["Happy", "Sadness", "Surprise", "Fear", "Anger", "Disgust", "Neutral" ]
    let array = [60.0, 50.0, 10.0, 10.0, 40.0, 30.0, 70.0]
    
    
    
    
    let overallColor = UIColor(displayP3Red: 249/255, green: 114/255, blue: 40/255, alpha: 1.0)
    let textLightColor = UIColor(displayP3Red: 255/255, green: 196/255, blue: 211/255, alpha: 1.0)
    let textDarkColor = UIColor(displayP3Red: 235/255, green: 81/255, blue: 190/255, alpha: 1.0)
    let voiceLightColor = UIColor(displayP3Red: 131/255, green: 182/255, blue: 255/255, alpha: 1.0)
    let voiceDarkColor = UIColor(displayP3Red: 66/255, green: 56/255, blue: 242/255, alpha: 1.0)
    let photoLightColor = UIColor(displayP3Red: 198/255, green: 192/255, blue: 255/255, alpha: 1.0)
    let photoDarkColor = UIColor(displayP3Red: 134/255, green: 114/255, blue: 244/255, alpha: 1.0)
    
    let circlevalues = [0.8, 0.4, 0.6]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GraphData.shared.textData = TextData(lineChartDays: graphArray, lineChartData: bardata1, emotions: subjects, emotionData: array)
        GraphData.shared.voiceData = VoiceData(contentLineChartDays: graphArray, contentLineChartData: bardata1, contentEmotions: subjects, contentEmotionData: array, toneLineChartDays: graphArray, toneLineChartData: bardata1)
        GraphData.shared.photoData = PhotoData(photoLineChartDays: graphArray, photoLineChartData: bardata1, videoLineChartDays: graphArray, videoLineChartData: bardata1, photoFacialUrls: [], photoFacialResults: [], photoNonFacialUrls: [], photoNonFacialResults: [], videoImages: [], videoResults: [])
        
        setNavigationBar()
        setProfileImageView()
        setOverviewView()
        setTableView()
        setTitleImage()
        // Do any additional setup after loading the view.
        circleChart(Values: circlevalues)
        
        let circles = [Double(GraphData.shared.voiceData.contentOverall) / 100, 0.2, Double(GraphData.shared.textData.overall) / 100]
        detailCircleChart(Values: circles)
    }
    
    func setNavigationBar() {
        let bar: UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    
    func setTitleImage() {
        let logo = UIImage(named: "titleLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
    func setProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
        profileImageView.layer.masksToBounds = true
        profileBGView.layer.cornerRadius = profileBGView.bounds.height/2
        profileBGView.layer.masksToBounds = true
    }
    
    func setOverviewView() {
        outerOverviewView.clipsToBounds = false
        outerOverviewView.layer.shadowColor = UIColor.black.cgColor
        outerOverviewView.layer.shadowOpacity = 0.1
        outerOverviewView.layer.shadowOffset = CGSize(width: 0, height: 10)
        outerOverviewView.layer.shadowRadius = 15
        
        overviewView.clipsToBounds = true
        overviewView.layer.cornerRadius = 15
        
        outerOverviewView.addSubview(overviewView)
    }
    
    func setTableView() {
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.1
        outerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        outerView.layer.shadowRadius = 15
//        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: 15).cgPath
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15
        
        outerView.addSubview(containerView)
    }

    func circleChart(Values: [Double]){
        let fgColor1 = overallColor
        let bgColor1 = UIColor.systemGray5
//        let fgColor2 = photoDarkColor
//        let fgColor3 = textDarkColor
        let rings = [
            ProgressRing(color: fgColor1, backgroundColor: bgColor1, width: 10),
//            ProgressRing(color: fgColor2, backgroundColor: bgColor1, width: 10),
//            ProgressRing(color: fgColor3, backgroundColor: bgColor1, width: 10),
        ]
        let margin: CGFloat = 2
        let radius: CGFloat = 60
        let progressRingView = ConcentricProgressRingView(center: CGPoint(x: overallCircleView.bounds.midX, y: overallCircleView.bounds.midY), radius: radius, margin: margin, rings: rings)
        progressRingView.arcs[0].setProgress(CGFloat(Values[0]), duration: 2)
//        progressRingView.arcs[1].setProgress(CGFloat(Values[1]), duration: 2)
//        progressRingView.arcs[2].setProgress(CGFloat(Values[2]), duration: 2)

        overallCircleView.addSubview(progressRingView)
        
    }
    
    func detailCircleChart(Values: [Double]){
        let fgColor1 = voiceDarkColor
        let bgColor1 = UIColor.systemGray5
        let fgColor2 = photoDarkColor
        let fgColor3 = textDarkColor
        let rings = [
            ProgressRing(color: fgColor1, backgroundColor: bgColor1, width: 10),
            ProgressRing(color: fgColor2, backgroundColor: bgColor1, width: 10),
            ProgressRing(color: fgColor3, backgroundColor: bgColor1, width: 10),
        ]
        let margin: CGFloat = 2
        let radius: CGFloat = 60
        let progressRingView = ConcentricProgressRingView(center: CGPoint(x: detailCircleView.bounds.midX, y: detailCircleView.bounds.midY), radius: radius, margin: margin, rings: rings)
        progressRingView.arcs[0].setProgress(CGFloat(Values[0]), duration: 2)
        progressRingView.arcs[1].setProgress(CGFloat(Values[1]), duration: 2)
        progressRingView.arcs[2].setProgress(CGFloat(Values[2]), duration: 2)

        detailCircleView.addSubview(progressRingView)
        
    }
    
    
    

    @IBAction func callButtonToggled(_ sender: Any) {
        print("calling")
        let handle = "01035198789"
        let videoEnabled = false
        
        let backgroundTaskIdentifier =
          UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            AppDelegate.shared.displayIncomingCall(
              uuid: UUID(),
              handle: handle,
              hasVideo: videoEnabled
            ) { _ in
              UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            }
        }
    }
    
    
    
    @IBAction func playRecording(_ sender: Any) {
        playAudio()
    }
    
    
    @IBAction func updateButtonToggled(_ sender: Any) {
        DispatchQueue.global(qos: .background).async {
            var result = Data()
            var statusCode = 502
            while statusCode==502 || statusCode==503 {
                let tup = self.sendUpdateRequest(url: updateUrl)
                result = tup.data
                statusCode = tup.statusCode
                print("re-reqesting")
                sleep(1)
            }
            let str = String(decoding: result, as: UTF8.self)
            print(str)
            self.parseAnnotations(result)
            DispatchQueue.main.async {
                self.circleChart(Values: self.circlevalues)
                let circles = [Double(GraphData.shared.voiceData.contentOverall) / 100, Double(GraphData.shared.photoData.photoOverall) / 100, Double(GraphData.shared.textData.overall) / 100]
                self.detailCircleChart(Values: circles)
                let overallTotal = circles.reduce(0, +)
                let overallAvg = overallTotal / 3
                self.circleChart(Values: [overallAvg])
                
                self.overallLabel.text = String(Int(overallAvg * 100)) + "%"
            }
            
        }
        
    }
    
    
    func buildRequestData() -> Data {
        
        let updateRequestObj = UpdateRequestObj(query: 1)
        
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(updateRequestObj)
        return jsonData
        
    }
    
    func sendUpdateRequest(url: String) -> (data: Data, statusCode: Int) {
        var resultData = Data()
        let postData = buildRequestData()
        var statusCode = -1
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                resultData = data
                let status = response as! HTTPURLResponse
                statusCode = status.statusCode
            }
            semaphore.signal()
            
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        
        return (resultData, statusCode)
        
    }
    
    private func parseAnnotations(_ data: Data) {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(ResponseObj.self, from: data)
            GraphData.shared.textData = TextData(lineChartDays: response.textDays, lineChartData: response.textValues, emotions: response.textEmotions, emotionData: response.textEmotionValues)
            GraphData.shared.voiceData = VoiceData(contentLineChartDays: response.voiceContentDays, contentLineChartData: response.voiceContentValues, contentEmotions: response.voiceContentEmotions, contentEmotionData: response.voiceContentEmotionValues, toneLineChartDays: response.voiceToneDays, toneLineChartData: response.voiceToneValues)
            GraphData.shared.photoData = PhotoData(photoLineChartDays: response.photoDays, photoLineChartData: response.photoValues, videoLineChartDays: graphArray, videoLineChartData: bardata1, photoFacialUrls: response.photoFacialUrl, photoFacialResults: response.photoFacialResult, photoNonFacialUrls: response.photoNonFacialUrl, photoNonFacialResults: response.photoNonFacialResult, videoImages: photoManager.photos, videoResults: facialResults)
            
        } catch let error {
            print("---> errort: \(error)")
            return
        }
    }
    
}
